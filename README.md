# Introduction
In this repository you will find the benchmark associated with the article "Can Software Containerisation Fit The Car On-Board Systems ?".

In this benchmark, we aim to test the performance of the different container runtimes in both mono-machine and multi-machine.

# Repository structure
|.
|| /install
||| install.sh
||| /mono_machine (give single node attribute)
|||| install_docker.sh
|||| install_lxc_lxd.sh
|||| install_k3s_default.sh (CRI-O runtime)
|||| install_k3s_containerd.sh
||| /multi_machine (give a list of nodes instead of a single node)
|||| install_docker.sh
|||| install_lxc_lxd.sh
|||| install_k3s_default.sh (CRI-O runtime)
|||| install_k3s_containerd.sh
|| /configure
||| sysbench_install.sh
||| /multi_mahine
|||| set_up_docker.sh
|||| set_up_lxc_lxd.sh
|||| set_up_k3s_default.sh (CRI-O runtime)
|||| set_up_k3s_containerd.sh
|| /tests
||| test_choice.sh
||| /test_apps
|||| /hello_world
|||| /fibonnaci
|||| /http_server
||| /mono_machine
|||| /cpu_overhead
||||| /docker (same for others)
|||||| test.sh (run/collect/treat/transform to csv)
|||||| collect_and_treat_results.sh (output csv)
|||||| dockerfile
||||| /lxc_lxd
||||| /k3s_default
||||| /k3s_containerd
|||| /memory_overhead
|||| /fileio
|||| /mutex_coordination
|||| /threads
|||| /build_time
|||| /steart_time
||| /multi_machine (increasing number of workers)
|||| /cpu_overhead 
|||| /memory_overhead
|||| /error_detection_time
|||| /app_deploy_time
|||| /app_migration_time
|| /test_results (same structure as before)
|| /final_paper
||| can_containers_fit_cars.pdf

# Test description
https://wiki.gentoo.org/wiki/Sysbench#Using_the_memory_workload

# Install / set-up
install.sh 
- mono ou multi machine
- techno
- si mono:
- master node
- si multi:
- master node
- liste de worker noeuds

va aller appeller les autres scripts et set up le cluster si multi-machine

# Mono-machine benchmarks
test_choice.sh arguments: 
- si tu veux nettoyer la machine ou pas (normalement oui)
- techno
- test à effectuer
- nombre de répetitions du test

test_choice.sh doit: 
- Si tu as voulu nettoyer
  - nettoyer tout la machine (docker prune, enlever fichiers résultats avant...)
  - build l'image test qu'on ait choisi
  - for nombre de repetitions
    - run container
    - collect results
    - stop / delete container
  - treat results, store sur csv à test_results
- Si tu as pas voulu nettoyer:
  - for nombre de repetitions
    - run container
    - collect results & treat results, store sur csv à test_results
    - stop / delete container
  - treat results, store sur csv à test_results

# Multi-machine benchamarks (on verra quand on sera la)
