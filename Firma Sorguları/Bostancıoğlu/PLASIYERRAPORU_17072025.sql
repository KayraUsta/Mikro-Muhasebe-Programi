[<
    <@P1;NAME=Baþlangýç tarihi,10;TYPE=T>
    <@P2;NAME=Bitiþ tarihi,10;TYPE=T>
>]

SELECT 
    'STOK' AS TIPI,
    sth_tarih AS TARIH,
    sth_evrakno_seri,
    sth_evrakno_sira,
    sth_plasiyer_kodu AS PLASIYER,
    cari_per_adi + ' ' + cari_per_soyadi AS ADI,
    pro_adi AS PROJE,
    som_isim AS SORM_MERKZ,
    stmuh_ismi AS GRUBU,
    sto_prim_kodu,
    sth_stok_kod AS STOK_HIZMET,
    sto_isim AS STOK_HIZMET_ADI,
    sth_miktar AS MIKTAR,
    sth_tutar AS TUTAR,
    sth_iskonto1 + sth_iskonto2 + sth_iskonto3 AS INDIRIM,
    sth_tutar - (sth_iskonto1 + sth_iskonto2 + sth_iskonto3) AS NET_SATIS,
    0 AS MALIYET,
    egk_evracik1 AS ACIKLAMA1,
    egk_evracik2 AS ACIKLAMA2,
    egk_evracik3 AS ACIKLAMA3,
    egk_evracik4 AS ACIKLAMA4
FROM STOK_HAREKETLERI WITH(NOLOCK) 
LEFT JOIN STOKLAR WITH(NOLOCK) ON sto_kod = sth_stok_kod
LEFT JOIN CARI_PERSONEL_TANIMLARI WITH(NOLOCK) ON cari_per_kod = sth_plasiyer_kodu 
LEFT JOIN STOK_ANA_GRUPLARI WITH(NOLOCK) ON san_kod = sto_anagrup_kod 
LEFT JOIN STOK_MUHASEBE_GRUPLARI WITH(NOLOCK) ON stmuh_kod = sto_muhgrup_kodu
LEFT JOIN PROJELER WITH(NOLOCK) ON pro_kodu = sth_proje_kodu
LEFT JOIN SORUMLULUK_MERKEZLERI WITH(NOLOCK) ON som_kod = sth_stok_srm_merkezi
LEFT JOIN EVRAK_ACIKLAMALARI WITH(NOLOCK) ON egk_dosyano = sth_fileid and egk_evr_seri = sth_evrakno_seri and egk_evr_sira = sth_evrakno_sira
WHERE sth_tarih BETWEEN @P1 AND @P2
    AND sth_tip = 1 
    AND sth_cins IN (0,1) 
    AND sth_evraktip = 4 
    AND sth_normal_iade = 0

UNION ALL

SELECT 
    'HÝZMET' AS TIPI,
    cha_tarihi,
    cha_evrakno_seri,
    cha_evrakno_sira,
    cha_satici_kodu,
    cari_per_adi + ' ' + cari_per_soyadi,
    pro_adi,
    som_isim,
    '', -- GRUBU
    '', -- sto_prim_kodu
    cha_kasa_hizkod,
    hiz_isim,
    cha_miktari,
    cha_aratoplam,
    cha_ft_iskonto1 + cha_ft_iskonto2 + cha_ft_iskonto3,
    cha_aratoplam - (cha_ft_iskonto1 + cha_ft_iskonto2 + cha_ft_iskonto3),
    0, -- MALIYET
    egk_evracik1,
    egk_evracik2,
    egk_evracik3,
    egk_evracik4
FROM CARI_HESAP_HAREKETLERI WITH(NOLOCK) 
LEFT JOIN HIZMET_HESAPLARI WITH(NOLOCK) ON hiz_kod = cha_kasa_hizkod
LEFT JOIN CARI_PERSONEL_TANIMLARI WITH(NOLOCK) ON cari_per_kod = cha_satici_kodu 
LEFT JOIN PROJELER WITH(NOLOCK) ON pro_kodu = cha_projekodu
LEFT JOIN SORUMLULUK_MERKEZLERI WITH(NOLOCK) ON som_kod = cha_srmrkkodu
LEFT JOIN EVRAK_ACIKLAMALARI WITH(NOLOCK) ON egk_dosyano = cha_fileid and egk_evr_seri = cha_evrakno_seri and egk_evr_sira = cha_evrakno_sira
WHERE cha_tarihi BETWEEN @P1 AND @P2
    AND cha_evrak_tip = 63 
    AND cha_kasa_hizmet = 3 
    AND cha_normal_Iade = 0 

ORDER BY TARIH
