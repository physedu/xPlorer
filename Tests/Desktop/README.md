# xPlorer — Desktop test candidate

Source: 1ef1a5afbb45542cb9cb05f9491a1b06e4f2ef39

1. Extract the whole ZIP. xAct must already be installed.
2. Restart Mathematica's kernel. Open xPlorer_Desktop_Check.nb and evaluate its Get cell. Do not use Needs for xPlorer or install a Paclet. The version string is still 1.0.0-beta.1; this is NOT the public archive.
3. Run sections 1–5 cell by cell. In particular inspect the Einstein perturbation outputs in section 2 and all three notation styles in section 3. There should be no red boxes or StringJoin/Table errors. In section 3, follow the manual copy/paste instruction before evaluating copy_check. The last two residuals must be zero.
4. Restart the kernel again. Open xPlorer_Workflow.nb and choose Get, not Needs, to run the full tutorial with this exact candidate source.

Please send screenshots of any failed cells, including messages, Mathematica/xAct version and OS. No installation or uninstallation is necessary.

The remote kernel passed 63/63 focused checks and 36/37 Workflow checks. The remaining check detects xTensor's CurrentValue[FontSize] returning $Failed in a headless kernel. Desktop review is specifically intended to distinguish that from an actual display failure. Full second-order Einstein components are not part of this test.
