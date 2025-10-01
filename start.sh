# Skrip Utama XipserCloud Server oleh Paongdev
# Fungsi: Setup otomatis, Random MOTD, Ngrok, Auto Shutdown 12 jam, Java Start.

# --- KONFIGURASI NGROK DAN SERVER ---
NGROK_TOKEN="33RKXoLi8mLMccvpJbo1LoN3fCg_4AEGykdpBZeXx2TFHaCQj"
SERVER_RAM=${SERVER_RAM:-4G} # Default 4GB, bisa diubah dengan 'export SERVER_RAM=6G'
SHUTDOWN_TIME=43200 # 12 Jam dalam detik
PLUGIN_DIR="plugins"

# --- FUNGSI TAMPILAN ---
display_banner() {
    clear
    echo "========================================================"
    echo "  XIPSERCLOUD MINECRAFT SERVER by PAONGDEV"
    echo "========================================================"
    echo "  RAM: $SERVER_RAM | Shutdown Otomatis: 12 Jam"
    echo "========================================================"
}

# --- FUNGSI AUTO SHUTDOWN (12 JAM) ---
auto_shutdown_timer() {
    sleep $SHUTDOWN_TIME # Menunggu 12 jam (43200 detik)
    
    # 1. Peringatan 5 menit
    screen -p 0 -S xipsercloud -X stuff 'say [Server] PEMBERITAHUAN: Server akan mati dalam 5 MENIT untuk istirahat dan stabilitas.^M'
    sleep 240 # Tunggu 4 menit
    
    # 2. Peringatan 1 menit
    screen -p 0 -S xipsercloud -X stuff 'say [Server] PEMBERITAHUAN: Server akan mati dalam 1 MENIT! Mulai save dunia...^M'
    sleep 60 # Tunggu 1 menit
    
    # 3. Shutdown Aman dan Pesan Istirahat
    screen -p 0 -S xipsercloud -X stuff 'stop^M'
    
    echo "========================================================"
    echo "🛑 SHUTDOWN OTOMATIS BERHASIL! Dunia sudah tersimpan."
    echo "   PESAN UNTUK SEMUA: Tolong Handphone Jangan Di Gunakan"
    echo "   Selama 1 jam buat istirahat dan stabilitas."
    echo "========================================================"
    # Membunuh semua proses terkait (Ngrok dan Java jika masih ada)
    killall java 2>/dev/null
    killall ngrok 2>/dev/null
}

# --- FUNGSI INSTALASI DAN SETUP KONFIGURASI ---
create_config_files() {
    echo "3. Membuat konfigurasi file plugin..."
    mkdir -p $PLUGIN_DIR/Essentials
    mkdir -p $PLUGIN_DIR/CrazyCrates/Crates

    # 3.1 Konten Buku Panduan (book.txt)
    cat <<EOF > $PLUGIN_DIR/Essentials/book.txt
[
  {
    "text": "&6&l>> Panduan XipserCloud <<\n\n&bProject by Paongdev\n&f---------------------\n\n&aSelamat Datang di XipserCloud Survival! Server ini anti-lag dan sangat stabil untuk mabar maraton 12 jam.",
    "color": "black"
  },
  {
    "text": "&6&lFITUR SERVER\n\n&b1. Claim Wilayah:\n&fAnda mendapat Sekop Emas untuk melindungi bangunan Anda dari griefing. Gunakan Sekop Emas dan klik 2 sudut untuk claim.\n\n&b2. Player Grave:\n&fSemua item aman di peti saat Anda mati (tidak despawn!).",
    "color": "black"
  },
  {
    "text": "&6&lFITUR VOICE CHAT\n\n&c[PERINGATAN WAJIB KLIKN]\n&fUntuk voice chat, Anda dan teman Anda &4WAJIB &fmemasang 3 Mod di Minecraft PC/Laptop (Fabric Loader, Fabric API, Simple Voice Chat Mod). Cek link di Panduan Luar.\n\n&bTombol default: &f'CAPS LOCK' atau 'V' untuk bicara.",
    "color": "black"
  },
  {
    "text": "&6&lDUNGEON & ARENA\n\n&bTantangan Monster:\n&fAdmin (Paongdev) telah membuat 'Gua Harta Karun'.\n\nArena ini aktif saat dipicu, penuh tantangan monster (zombie, dll) yang terkontrol (tidak menumpuk).",
    "color": "black"
  },
  {
    "text": "&6&lHADIAH DUNGEON\n\n&fCrate hadiah bisa didapat setelah menaklukkan arena. Ada 5 Tingkat Kelangkaan:\n\n&4- Sangat Langka\n&c- Langka\n&6- Lumayan\n&e- Biasa\n&a- Dasar",
    "color": "black"
  }
]
EOF

    # 3.2 Crazy Crate - Dungeon.yml (5 TIngkat Kelangkaan)
    cat <<EOF > $PLUGIN_DIR/CrazyCrates/Crates/Dungeon.yml
# Crazy Crates Configuration for XipserCloud Dungeon

CrateName: Dungeon
CrateType: cs
Preview:
  Name: "&6&lHadiah Dungeon"
  Glass: black_stained_glass_pane
  Display: diamond_block
  Slot: 10
  Starting-Chance: 100

Prizes:
  Sangat_Langka:
    DisplayName: "&4&lSANGAT LANGKA"
    Chance: 2.0 # 2% Chance (ELYTRA, NETHERITE)
    MaxRange: 1
    DisplayItem: netherite_block
    DisplayEnchanted: true
    Items:
      - 'elytra 1'
      - 'netherite_ingot 4'
      - 'diamond_block 16'
      - 'spawner 1'
    
  Langka:
    DisplayName: "&c&lLANGKA"
    Chance: 8.0 # 8% Chance (DIAMONDS, BEACON)
    MaxRange: 1
    DisplayItem: diamond
    Items:
      - 'diamond 32'
      - 'beacon 1'
      - 'diamond_pickaxe 1 sharpness:5 efficiency:5 unbreaking:3'
      - 'experience_bottle 32'
      
  Lumayan:
    DisplayName: "&6&lLUMAYAN"
    Chance: 20.0 # 20% Chance (GOLD, IRON)
    MaxRange: 1
    DisplayItem: gold_ingot
    Items:
      - 'gold_ingot 64'
      - 'iron_ingot 64'
      - 'enchanting_table 1'
      
  Biasa:
    DisplayName: "&e&lBIASA"
    Chance: 35.0 # 35% Chance (FOOD, LEATHER)
    MaxRange: 1
    DisplayItem: cooked_beef
    Items:
      - 'cooked_beef 64'
      - 'leather 16'
      - 'arrow 32'

  Dasar:
    DisplayName: "&a&lDASAR"
    Chance: 35.0 # 35% Chance (COAL, STICK)
    MaxRange: 1
    DisplayItem: coal
    Items:
      - 'coal 64'
      - 'torch 64'
      - 'stick 32'
EOF

    # 3.3 Konfigurasi EssentialsX (untuk Buku Panduan)
    cat <<EOF > $PLUGIN_DIR/Essentials/config.yml
# XipserCloud EssentialsX Configuration (Customized)
# Mengaktifkan Player Heads, Kit Awal, dan BUKU PANDUAN OTOMATIS.

teleport-safety: true
starting-balance: 0.0

kits:
  tools:
    delay: 10
    items:
      - written_book 1 title:&6&lPanduan_XipserCloud author:&bPaongdev pages:8 lore:Panduan_Resmi_Server_XipserCloud
      - 284 1 name:&6Sekop_Emas_CLAIM # Golden Shovel (284) untuk Claim
      - 294 1 name:&6Cangkul_Emas_AUTHORIZE # Golden Hoe (294) untuk Otorisasi Pukul
      - 280 1 name:&fTongkat_Pengecek_Wilayah # Stick (280) untuk cek batas claim
  initial-kit: tools # AKTIF: Memberikan kit 'tools' saat pemain pertama kali masuk
  
player-kills-drop-heads: true # AKTIF: Player Head (Kepala Pemain) jatuh saat dibunuh.

tpa-cooldown: 5 
homes:
  max-homes: 3 
EOF

    echo "4. Menyetel eula.txt dan ngrok.yml..."
    echo "eula=true" > eula.txt
    
    cat <<EOF > ngrok.yml
version: "2"
authtoken: $NGROK_TOKEN
tunnels:
  minecraft:
    proto: tcp
    addr: 25565
    region: ap
EOF
}

initial_setup() {
    if [ ! -f paper.jar ]; then
        echo "1. Mendownload PaperMC 1.20.4..."
        wget -q -O paper.jar "https://api.papermc.io/v2/projects/paper/versions/1.20.4/builds/514/downloads/paper-1.20.4-514.jar"
        echo "   PaperMC berhasil diunduh."
    fi

    if [ ! -d $PLUGIN_DIR ]; then
        echo "2. Mendownload Plugin Canggih (Voice Chat, Grave, Arena, Crates)..."
        mkdir -p $PLUGIN_DIR
        # Mendownload Plugin
        wget -q -O $PLUGIN_DIR/EssentialsX.jar "https://github.com/EssentialsX/EssentialsX/releases/download/2.20.1/EssentialsX-2.20.1.jar"
        wget -q -O $PLUGIN_DIR/GriefPrevention.jar "https://github.com/TechFortress/GriefPrevention/releases/download/16.18/GriefPrevention-16.18.jar"
        wget -q -O $PLUGIN_DIR/MobArena.jar "https://github.com/MobArena/MobArena/releases/download/0.109.1/MobArena-0.109.1.jar"
        wget -q -O $PLUGIN_DIR/CrazyCrates.jar "https://github.com/CrazyCrates/CrazyCrates/releases/download/3.3.0/CrazyCrates-3.3.0.jar"
        wget -q -O $PLUGIN_DIR/PlayerGrave.jar "https://github.com/PlayerGrave/PlayerGrave/releases/download/2.0.0/PlayerGrave-2.0.0.jar"
        wget -q -O $PLUGIN_DIR/SimpleVoiceChat.jar "https://github.com/acmc/simple-voice-chat/releases/download/v2.4.0/Simple-Voice-Chat-2.4.0-fabric.jar"
        echo "   Semua plugin berhasil diunduh."
    fi

    if [ ! -f $PLUGIN_DIR/Essentials/config.yml ]; then
        create_config_files
        echo "   Konfigurasi Plugin Otomatis Selesai."
    fi
}

# --- FUNGSI START UTAMA ---
start_server() {
    display_banner
    echo "1. Mempersiapkan Ngrok..."
    
    # Menjalankan Ngrok di latar belakang
    ngrok start --all --config ngrok.yml > /dev/null 2>&1 &
    
    ATTEMPTS=0
    IP_ADDRESS=""
    
    while [ -z "$IP_ADDRESS" ] && [ $ATTEMPTS -lt 10 ]; do
        IP_ADDRESS=$(curl --silent --show-error --connect-timeout 5 http://127.0.0.1:4040/api/tunnels | grep -o 'tcp://[^"]*' | head -n 1)
        if [ -z "$IP_ADDRESS" ]; then
            echo "   ...Menunggu IP Ngrok ($((ATTEMPTS + 1))/10)"
            sleep 5
            ATTEMPTS=$((ATTEMPTS + 1))
        fi
    done

    if [ -z "$IP_ADDRESS" ]; then
        echo "--------------------------------------------------------"
        echo "🛑 GAGAL TOTAL MENDAPATKAN IP NGROK setelah 10 percobaan!"
        echo "   CEK: Token Anda valid (ngrok.yml) atau Koneksi Internet."
        echo "--------------------------------------------------------"
        exit 1
    fi
    
    # Membersihkan format tcp://
    CLEAN_IP=$(echo "$IP_ADDRESS" | sed 's/tcp:\/\///')
    
    # --- OUTPUT ALAMAT YANG JELAS ---
    echo ""
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║         ✅ ALAMAT SERVER XIPSERCLOUD SUDAH AKTIF!             ║"
    echo "╠══════════════════════════════════════════════════════════╣"
    echo "║ BAGIKAN ALAMAT INI KE TEMAN ANDA:                          ║"
    echo "║   >>>  $CLEAN_IP  <<<                                      ║"
    echo "║                                                          ║"
    echo "║ (Alamat ini adalah Domain:Port gabungan, siap di-copy.)  ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo ""

    # Menjalankan Timer Shutdown di latar belakang
    auto_shutdown_timer &

    # Menjalankan Server Java di dalam sesi screen
    echo "2. Memulai Server PaperMC (Konsol berada di sesi screen: xipsercloud)"
    screen -dmS xipsercloud bash -c "java -Xms1G -Xmx$SERVER_RAM -jar paper.jar --nogui"
    echo "   Server Berhasil Dimulai. Cek konsol dengan: screen -r xipsercloud"
}

# --- PROSES EKSEKUSI ---
# Kill existing processes before starting
killall java 2>/dev/null
killall ngrok 2>/dev/null

initial_setup
start_server

# Script utama selesai, output akan dialihkan ke nohup.out
EOF

### **File 3: Konfigurasi Server (server.properties)**
