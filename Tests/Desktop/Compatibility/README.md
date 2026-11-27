# xPlorer — compatibility fix candidate

Source and notebook commit: 51d9fae87c8aed6d76be46db4b468309e351a122

Extract the whole ZIP. Restart the kernel. Open xPlorer_Compatibility_Check.nb and evaluate the Get cell. Do not install a Paclet. Run the three numbered sections in order. The named-index display in section 2 should contain no red boxes or formatting errors. In section 3, the explicit wrong-background request must return ForeignBackground; all Boolean checks must be True. The ordinary component results remain 2 and 7.

The full Workflow and API Examples are included for optional separate fresh-kernel runs, choosing Get, not Needs. The version is still 1.0.0-beta.1. This is a development candidate, not an installed public release.

Remote checks: 65/65 compatibility checks, 37/37 Workflow checks (153 inputs), 109/109 API checks and 33/33 stages (419 inputs). The earlier candidate's original Einstein rendering and manual copy/paste were confirmed in Desktop. Named indices on this new source still require visual confirmation. The native headless FontSize diagnostic is handled only in the test runner, not the package.
