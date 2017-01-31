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
echo "xvlog -m64 --relax -prj counter_natural_test_vlog.prj"
ExecStep $xv_path/bin/xvlog -m64 --relax -prj counter_natural_test_vlog.prj 2>&1 | tee compile.log
