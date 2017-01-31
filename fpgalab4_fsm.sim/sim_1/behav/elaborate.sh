#!/bin/bash -f
xv_path="/software/xilinx-2015/Vivado/2015.4"
ExecStep()
{
"$@"
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
exit $RETVAL
fi
}
ExecStep $xv_path/bin/xelab -wto aad3b197af4b47a5aff987c3619fab7a -m64 --debug typical --relax --mt 8 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot counter_natural_test_behav xil_defaultlib.counter_natural_test xil_defaultlib.glbl -log elaborate.log
