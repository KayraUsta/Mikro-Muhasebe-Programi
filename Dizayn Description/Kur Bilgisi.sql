ItemData7 = %%SQL.SELECT 
    'KUR: ' + CONVERT(varchar, dbo.fn_KurBul(S.sth_tarih, 2, 4)) AS EUR_EfektifSatisKuru
FROM CARI_HESAP_HAREKETLERI AS C
LEFT OUTER JOIN STOK_HAREKETLERI AS S ON S.sth_fat_uid = C.cha_Guid
WHERE C.cha_Guid = @CGUID%%

ItemData6 = %%SQL.SELECT 
    'KUR: ' + CONVERT(varchar, dbo.fn_KurBul(S.sth_tarih, 1, 4)) AS USD_EfektifSatisKuru
FROM CARI_HESAP_HAREKETLERI AS C
LEFT OUTER JOIN STOK_HAREKETLERI AS S ON S.sth_fat_uid = C.cha_Guid
WHERE C.cha_Guid = @CGUID%%

ItemData7 = %%SQL.SELECT 
    'KUR: USD = ' + CONVERT(varchar, dbo.fn_KurBul(S.sth_tarih, 1, 4)) + 
    ', EUR = ' + CONVERT(varchar, dbo.fn_KurBul(S.sth_tarih, 2, 4)) AS KurBilgisi
FROM CARI_HESAP_HAREKETLERI AS C
LEFT OUTER JOIN STOK_HAREKETLERI AS S ON S.sth_fat_uid = C.cha_Guid
WHERE C.cha_Guid = @CGUID%%