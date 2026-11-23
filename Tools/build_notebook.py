# Rebuild the principal notebook with Python 3; no third-party dependencies.
# Input boxes are generated with Tools/MakeInputBoxes.wl when code cells change.
from pathlib import Path
import json
import re
ROOT = Path(__file__).resolve().parent.parent
cells = json.loads((ROOT/'Tools/tutorial_cells.json').read_text())
native=json.loads((ROOT/'Tools/input_boxes.json').read_text())
formulas=json.loads((ROOT/'Tools/formula_boxes.json').read_text())
def wl(s):return json.dumps(s,ensure_ascii=True)
def prose(s):
    parts=re.split(r'(`[^`]+`)',s)
    boxes=[]
    for part in parts:
        if part.startswith('`') and part.endswith('`'):
            boxes.append('StyleBox['+wl(part[1:-1])+',FontFamily->"Courier",FontSize->11]')
        elif part:
            boxes.append(wl(part))
    return 'TextData[{'+','.join(boxes)+'}]'
output=[];chapter=[]
def flush():
    if chapter:
        output.append('Cell[CellGroupData[{\n'+',\n\n'.join(chapter)+'\n},Open]]');chapter.clear()
for c in cells:
    if c['kind']=='input':
        rendered='Cell[BoxData['+native[c['code']]+'],"Input",CellTags->'+wl(c['id'])+']'
    elif c['kind']=='formula':
        rendered='Cell[BoxData['+formulas[c['id']]+'],"DisplayFormula"]'
    elif c['style']=='Program':
        rendered='Cell['+wl(c['text'])+',"Program",Evaluatable->False]'
    else:
        rendered='Cell['+prose(c['text'])+','+wl(c['style'])+']'
    if c.get('style')=='Section':
        flush();chapter.append(rendered)
    elif chapter:
        chapter.append(rendered)
    else:
        output.append(rendered)
flush()
styles='''Notebook[{
 Cell[StyleData[StyleDefinitions -> "Default.nb"]],
 Cell[StyleData["Title"], FontSize -> 28, FontWeight -> "Bold"],
 Cell[StyleData["Subtitle"], FontSize -> 14, FontSlant -> "Italic"],
 Cell[StyleData["Section"], FontSize -> 22, FontWeight -> "Bold"],
 Cell[StyleData["Subsection"], FontSize -> 16, FontWeight -> "Bold"],
 Cell[StyleData["Text"], FontSize -> 12, LineSpacing -> {1.2,0}],
 Cell[StyleData["Input"], FontSize -> 12, CellFrame -> {{1,0},{0,0}}, CellFrameMargins -> {{10,8},{6,6}}],
 Cell[StyleData["Output"], FontSize -> 12],
 Cell[StyleData["DisplayFormula"], FontSize -> 14],
 Cell[StyleData["Important"], FontSize -> 12, FontWeight -> "Bold", LineSpacing -> {1.2,0}, CellMargins -> {{66,10},{8,8}}, CellFrame -> {{2,0},{0,0}}, CellFrameMargins -> {{10,8},{7,7}}],
 Cell[StyleData["Tip"], FontSize -> 12, FontSlant -> "Italic", LineSpacing -> {1.2,0}, CellMargins -> {{78,10},{8,8}}, CellFrameMargins -> {{10,8},{6,6}}],
 Cell[StyleData["Program"], FontSize -> 11, CellFrame -> {{0.5,0},{0,0}}, CellFrameMargins -> {{10,8},{6,6}}]
},Visible->False,StyleDefinitions->"PrivateStylesheetFormatting.nb"]'''
nb='(* Wolfram Notebook File - ASCII source *)\nNotebook[{\n'+',\n\n'.join(output)+'\n},WindowTitle->"xPlorer - Theory and backgrounds",StyleDefinitions->'+styles+',Saveable->True]\n'
assert nb.isascii()
(ROOT/'xPlorer_Workflow.nb').write_text(nb,encoding='ascii')
print('Wrote tutorial:',len(cells),'cells; eight sections; styles embedded')
