INSERT INTO VERILEN_TEKLIFLER 
(tkl_Guid
 ,tkl_DBCno
 ,tkl_SpecRECno
 ,tkl_iptal
 ,tkl_fileid
 ,tkl_hidden
 ,tkl_kilitli
 ,tkl_degisti
 ,tkl_checksum
 ,tkl_create_user
 ,tkl_create_date
 ,tkl_lastup_user
 ,tkl_lastup_date
 ,tkl_special1
 ,tkl_special2
 ,tkl_special3
 ,tkl_firmano
 ,tkl_subeno
 ,tkl_stok_kod
 ,tkl_cari_kod
 ,tkl_evrakno_seri
 ,tkl_evrakno_sira
 ,tkl_evrak_tarihi
 ,tkl_satirno
 ,tkl_belge_no
 ,tkl_belge_tarih
 ,tkl_asgari_miktar
 ,tkl_teslimat_suresi
 ,tkl_baslangic_tarihi
 ,tkl_Gecerlilik_Sures
 ,tkl_Brut_fiyat
 ,tkl_Odeme_Plani
 ,tkl_miktar
 ,tkl_Aciklama
 ,tkl_doviz_cins
 ,tkl_doviz_kur
 ,tkl_alt_doviz_kur
 ,tkl_vergi_pntr
 ,tkl_vergi
 ,tkl_masraf_vergi_pnt
 ,tkl_masraf_vergi
 ,TKL_TESLIMTURU
 ,tkl_ProjeKodu
 ,tkl_Sorumlu_Kod
 ,tkl_adres_no
 ,tkl_yetkili_uid
 ,tkl_durumu
 ,tkl_TedarikEdilecekCari
 ,tkl_fiyat_liste_no
 ,tkl_Birimfiyati
 ,tkl_paket_kod
 ,tkl_teslim_miktar
 ,tkl_OnaylayanKulNo
 ,tkl_cagrilabilir_fl
 ,tkl_harekettipi
 ,tkl_cari_sormerk
 ,tkl_stok_sormerk
 ,tkl_kapatmanedenkod
 ,tkl_servisisemrikodu
 ,tkl_birim_pntr
 ,tkl_cari_tipi
) 
SELECT
NEWID() -- tkl_Guid
,0 -- tkl_DBCno
,0 -- tkl_SpecRECno
,0 -- tkl_iptal
,100 -- tkl_fileid
,0 -- tkl_hidden
,0 -- tkl_kilitli
,0 -- tkl_degisti
,0 -- tkl_checksum
,1 -- tkl_create_user
,GETDATE() -- tkl_create_date
,1 -- tkl_lastup_user
,GETDATE() -- tkl_lastup_date
,N'' -- tkl_special1
,N'' -- tkl_special2
,N'' -- tkl_special3
,0 -- tkl_firmano
,0 -- tkl_subeno
,dt.UrunIsmi -- tkl_stok_kod
,%cari_ismi% -- tkl_cari_kod
,N'EFL' -- tkl_evrakno_seri
,%evrak_sira% -- tkl_evrakno_sira
,GETDATE() -- tkl_evrak_tarihi
,ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) -- tkl_satirno
,%teklif_no% -- tkl_belge_no
,GETDATE() -- tkl_belge_tarih
,0 -- tkl_asgari_miktar
,0 -- tkl_teslimat_suresi
,GETDATE() -- tkl_baslangic_tarihi
,dt.TeslimTarihi -- tkl_Gecerlilik_Sures
,dt.Tutari -- tkl_Brut_fiyat
,0 -- tkl_Odeme_Plani
,dt.Miktar -- tkl_miktar
,N'' -- tkl_Aciklama
,0 -- tkl_doviz_cins
,1.000000000000 -- tkl_doviz_kur
,38.595300 -- tkl_alt_doviz_kur
,1 -- tkl_vergi_pntr
,0 -- tkl_vergi
,0 -- tkl_masraf_vergi_pnt
,0 -- tkl_masraf_vergi
,N'' -- tkl_TeslimTuru
,N'' -- tkl_ProjeKodu
,%satis_temsilcisi% -- tkl_Sorumlu_Kod
,1 -- tkl_adres_no
,'00000000-0000-0000-0000-000000000000' -- tkl_yetkili_uid
,0 -- tkl_durumu
,N'' -- tkl_TedarikEdilecekCari
,0 -- tkl_fiyat_liste_no
,dt.BirimFiyat -- tkl_Birimfiyati
,N'' -- tkl_paket_kod
,0 -- tkl_teslim_miktar
,0 -- tkl_OnaylayanKulNo
,1 -- tkl_cagrilabilir_fl
,0 -- tkl_harekettipi
,N'' -- tkl_cari_sormerk
,N'' -- tkl_stok_sormerk
,N'' -- tkl_kapatmanedenkod
,N'' -- tkl_servisisemrikodu
,1 -- tkl_birim_pntr
,0 -- tkl_cari_tipi
FROM (
    SELECT 
        x.Rec.query('./ColumnData[1]').value('.', 'bit') AS Sec,
        x.Rec.query('./ColumnData[2]').value('.', 'NVARCHAR(MAX)') AS UrunIsmi,
        x.Rec.query('./ColumnData[3]').value('.', 'NVARCHAR(MAX)') AS Miktar,
        x.Rec.query('./ColumnData[4]').value('.', 'NVARCHAR(MAX)') AS Birim,
        x.Rec.query('./ColumnData[5]').value('.', 'NVARCHAR(MAX)') AS BirimFiyat,
        x.Rec.query('./ColumnData[6]').value('.', 'NVARCHAR(MAX)') AS Iskonto,
        x.Rec.query('./ColumnData[7]').value('.', 'NVARCHAR(MAX)') AS KDV,
		x.Rec.query('./ColumnData[8]').value('.', 'NVARCHAR(MAX)') AS Tutari,
		x.Rec.query('./ColumnData[9]').value('.', 'NVARCHAR(MAX)') AS ParaBirimi,
        x.Rec.query('./ColumnData[10]').value('.', 'NVARCHAR(MAX)') AS KDVliTutar,
        x.Rec.query('./ColumnData[11]').value('.', 'date') AS TeslimTarihi,
        x.Rec.query('./ColumnData[12]').value('.', 'NVARCHAR(MAX)') AS IskontoTutari,
        x.Rec.query('./ColumnData[13]').value('.', 'NVARCHAR(MAX)') AS SatisPrimTutari
    FROM  
    (
        SELECT cast(VALUE as XML) as xdt 
        FROM EFLOW.DBO.INST_DATA_MEMO
        WHERE DID=13862 AND CIID=%surec_id%
    ) e
    CROSS APPLY e.xdt.nodes('/LineItemTable/TableData/Data') as x(Rec)
) dt;
