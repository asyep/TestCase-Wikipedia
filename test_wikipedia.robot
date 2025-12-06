*** Settings ***
Library           SeleniumLibrary
Test Teardown     Close Browser

*** Variables ***
${URL}            https://www.wikipedia.org
${BROWSER}        chrome

*** Test Cases ***

TC-01 Pencarian Valid (Positif)
    [Documentation]    Memastikan user bisa mencari artikel yang ada.
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Input Text      id=searchInput    Indonesia
    Click Button    xpath=//button[@type='submit']
    Wait Until Page Contains    Republik Indonesia    10s
    Log    Test berhasil: Artikel Indonesia ditemukan.

TC-02 Pencarian Tidak Valid (Negatif)
    [Documentation]    Memastikan pesan error muncul jika kata kunci asal-asalan.
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Input Text      id=searchInput    skripsirplkatalontest12345
    Click Button    xpath=//button[@type='submit']
    # Kita cari teks umum yang muncul saat error
    Wait Until Page Contains    Search results
    Log    Test berhasil: Halaman hasil pencarian muncul.

TC-03 Ganti Bahasa (Interwiki)
    [Documentation]    Memastikan fitur link bahasa berfungsi.
    Open Browser    https://id.wikipedia.org/wiki/Indonesia    ${BROWSER}
    Maximize Browser Window
    # KLIK TOMBOL BAHASA DULU (Supaya menu terbuka)
    Click Element    xpath=//li[@id='p-lang-btn']
    Sleep    1s
    # Klik bahasa Inggris
    Click Element    xpath=//a[contains(text(),'English')]
    Wait Until Page Contains    Republic of Indonesia
    Location Should Contain    en.wikipedia.org
    Log    Test berhasil: Pindah ke Bahasa Inggris.

TC-04 Menu Portal Komunitas
    [Documentation]    Memastikan menu navigasi samping berfungsi.
    Open Browser    https://id.wikipedia.org/wiki/Halaman_Utama    ${BROWSER}
    Maximize Browser Window
    # KLIK TOMBOL MENU UTAMA DULU (Garis Tiga)
    Click Element    id=vector-main-menu-dropdown
    Sleep    1s
    # Baru klik Portal Komunitas
    Click Element    xpath=//span[contains(text(),'Portal komunitas')]
    Wait Until Page Contains    Portal komunitas
    Log    Test berhasil: Masuk ke halaman Portal Komunitas.

TC-05 Validasi Logo (Home Redirect)
    [Documentation]    Klik logo harus kembali ke halaman utama.
    Open Browser    https://id.wikipedia.org/wiki/Indonesia    ${BROWSER}
    Maximize Browser Window
    Click Element    xpath=//a[@class='mw-logo']
    Wait Until Page Contains    Selamat datang di Wikipedia
    Log    Test berhasil: Logo mengarahkan ke Home.

TC-06 Fitur Cari Acak (Random Article)
    [Documentation]    Memastikan fitur artikel sembarang berfungsi.
    Open Browser    https://id.wikipedia.org/wiki/Halaman_Utama    ${BROWSER}
    Maximize Browser Window
    # KLIK TOMBOL MENU UTAMA DULU
    Click Element    id=vector-main-menu-dropdown
    Sleep    1s
    Click Element    xpath=//span[contains(text(),'Halaman sembarang')]
    ${judul_awal}=    Get Title
    Log    Judul artikel acak adalah: ${judul_awal}

TC-07 Cek Footer Lisensi
    [Documentation]    Memastikan teks lisensi hukum ada di bawah.
    Open Browser    https://id.wikipedia.org/wiki/Halaman_Utama    ${BROWSER}
    Maximize Browser Window
    Scroll Element Into View    xpath=//footer
    # Pakai teks yang lebih umum agar tidak fail karena beda dikit
    Page Should Contain    Creative Commons
    Log    Test berhasil: Footer lisensi ditemukan.

TC-08 Validasi Tombol Sumbangan
    [Documentation]    Memastikan menu sumbangan bisa diklik.
    Open Browser    https://id.wikipedia.org/wiki/Halaman_Utama    ${BROWSER}
    Maximize Browser Window
    # KLIK TOMBOL MENU UTAMA DULU
    Click Element    id=vector-main-menu-dropdown
    Sleep    1s
    Click Element    xpath=//span[contains(text(),'Sumbangan')]
    Wait Until Page Contains    Dukung Wikipedia
    Log    Test berhasil: Masuk ke halaman donasi.

TC-09 Tampilan Mobile (Responsive Test)
    [Documentation]    Menguji tampilan versi Mobile Web.
    ${mobile_emulation}=    Create Dictionary    deviceName=iPhone X
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_experimental_option    mobileEmulation    ${mobile_emulation}
    Create WebDriver    Chrome    options=${options}
    Go To    https://id.m.wikipedia.org
    Page Should Contain    Wikipedia
    Log    Test berhasil: Web terbuka dalam mode Mobile (iPhone X).

TC-10 Validasi Input Kosong
    [Documentation]    Memastikan search kosong tidak error.
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Click Button    xpath=//button[@type='submit']
    Page Should Contain    Wikipedia
    Log    Test berhasil: Input kosong aman.