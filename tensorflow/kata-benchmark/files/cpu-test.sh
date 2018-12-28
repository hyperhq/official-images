for i in `seq 1 5`; do echo "==========test num $i========"; sysbench cpu --events=20000 run; done
