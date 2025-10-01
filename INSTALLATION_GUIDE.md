Panduan Server XIPSERCLOUD by Paongdev: Server Java Edition Canggih
Selamat datang di XipserCloud! Server ini sudah dioptimalkan untuk performa tinggi di Termux (PaperMC) dan memiliki fitur Survival modern yang canggih.
1. Persiapan Termux (Wajib)
 * Instal Paket Dasar (Jika belum):
   pkg update && pkg upgrade -y
pkg install openjdk-17 wget unzip curl screen -y

 * Buat Folder Server:
   mkdir XipserCloud-Server
cd XipserCloud-Server

 * SALIN 5 FILE: Salin semua 5 file yang ada di sini ke dalam folder XipserCloud-Server.
 * Beri Izin Eksekusi:
   chmod +x start.sh

2. PENGATURAN RAM dan START
A. Pengaturan RAM (Opsional Upgrade)
Secara default, server menggunakan 4GB RAM. Untuk mengubahnya (misalnya ke 6GB), ketik ini SEBELUM menjalankan start.sh:
export SERVER_RAM=6G

B. Jalankan Server (Hanya 1 Perintah)
 * Aktifkan Wake Lock (Penting agar HP tidak tidur):
   Di jendela Termux terpisah, jalankan:
   termux-wake-lock

 * Jalankan Skrip Server di Latar Belakang (Otomatis Setup):
   Di folder server (XipserCloud-Server), jalankan:
   nohup ./start.sh &

   Server akan otomatis mengunduh, mengkonfigurasi semua plugin, dan membuat Buku Panduan.
🎯 ALAMAT SERVER (IP dan Port)
Tunggu 30-60 detik. Untuk melihat alamat yang harus dibagikan:
cat nohup.out

Output akan menampilkan alamat IP/Port dalam kotak yang jelas.
3. Fitur Utama & Guide
📚 Buku Panduan XipserCloud (Otomatis)
Setiap pemain baru akan otomatis menerima Buku Panduan XipserCloud yang menjelaskan:
 * Cara menggunakan Voice Chat (wajib instal MOD klien).
 * Cara Claim Wilayah (Sekop Emas).
 * Cara ikut Dungeon/Arena Monster.
❗ Voice Chat (Wajib Instal Klien)
Fitur ini TIDAK BISA otomatis sepenuhnya. Setiap pemain WAJIB menginstal Fabric Loader, Fabric API, dan Simple Voice Chat Mod (.jar) versi 1.20.4 ke folder mods mereka.
Fitur Admin & Dungeon:
 * Menjadi Operator (OP): Akses konsol: screen -r xipsercloud. Ketik (tanpa /): op [NamaPemainAnda].
 * Membuat Dungeon Arena: Gunakan perintah admin di game untuk membuat arena:
   * Buat Arena: /ma new DungeonGua
   * Atur Pintu Masuk: /ma set DungeonGua spawn
   * Hubungkan Hadiah: /ma set DungeonGua reward crazycrates:Dungeon
   * Selesaikan: /ma save DungeonGua
