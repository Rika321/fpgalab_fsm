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
ExecStep $xv_path/bin/xsim counter_natural_test_behav -key {Behavioral:sim_1:Functional:counter_natural_test} -tclbatch counter_natural_test.tcl -log simulate.log
