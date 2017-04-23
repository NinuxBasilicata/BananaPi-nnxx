# LEDE NNXX for BANANA-PI - LAMOBO-R1

[![N|Solid](http://basilicata.ninux.org/images/Logo_Ninux_Basilicata_600-192.png)](http://basilicata.ninux.org)

Compilazione di LEDE per HW AllWinner, esempio LAMOBO-R1

# Clonare il repo con:
```sh
git clone https://github.com/NinuxBasilicata/BananaPi-nnxx.git
```
- editare il file compile.sh per settare le variabili
- eseguire il file ./compile-lede.sh
- eseguire il file ./compile-openwrt.sh

Al termine usare il comando

```sh
gunzip -c tuo:file.img.gz |sudo dd of=/dev/sdx
```
