# SoC_initial

1. instalar litex https://github.com/enjoy-digital/litex
2. Descargar el paquete WP04
3. ingresar en un terminal a la carpeta ´SoC_project´
4. ejecutar "python3 buildSoCproject.py"
5. djtgcfg prog -d NexysA7 -i 0 -f ./build/nexys4ddr/gateware/nexys4ddr.bit
6. ir a la carpeta  firmware
7. ejecutar "make all"
8. salir de la carpeta firmware  
9. ejecutar litex_term.py /dev/ttyUSB1 --kernel firmware/firmware.bin
10.  enteder el programa que esta  ejecutando el procesardor 

