for i in `seq 1 5`; do echo "==========test num $i========"; sysbench memory  --memory-access-mode=rnd run; done
