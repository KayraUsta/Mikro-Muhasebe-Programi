[<
	<@H;@P1 -  @P2 / ARAÇ SATIÞ RAPORU - BOSTANCIOÐLU OTOMOTÝV>
	<@P1;NAME=Baþlangýç tarihi,10;TYPE=T>
	<@P2;NAME=Bitiþ tarihi,10;TYPE=T>
>]
--- 001
DECLARE @ILKTARIH AS DATE       
DECLARE @SONTARIH AS DATE 
SET     @ILKTARIH = @P1
SET     @SONTARIH = @P2


SELECT 
[SIFIR / 2.EL / DEMÝRBAÞ],
[MÜÞTERÝ],
[VKN_NO],
[BELGE NO],
[SATIÞ DANIÞMANI],
[ÞASE],
[ADI],
ISNULL([GÝRÝÞ TARÝHÝ],'') AS [GÝRÝÞ TARÝHÝ],
[VADE TARÝHÝ],
[ALIÞ TUTARI],
[ALIÞ KDV],
[ALIÞ TUTARI KDV DAHÝL],
[ALIÞ ÝSKONTO],
[ALIÞ ÝSKONTO KDV],
[SATIÞ ÝSKONTO],
[SATIÞ ÝSKONTO KDV],
[GÝRÝÞ MALÝYETÝ],
[SATIÞ TARÝHÝ],
[SATIÞ TUTARI],
[SATIÞ ÖTV],
[SATIÞ KDV],
[SATIÞ VERGÝLER DAHÝL],
[KAR - VERGÝSÝZ],
([KAR - VERGÝSÝZ] / [GÝRÝÞ MALÝYETÝ]) * 100 AS [VERGÝSÝZ KAR %],
[STOKTA BEKLEME GÜN SAYISI],
[FÝNANSMAN GÜN SAYISI] AS [FÝNANSMAN GÜN SAYISI],
(([ALIÞ TUTARI KDV DAHÝL] * 0.6)/365) *  CASE WHEN [FÝNANSMAN GÜN SAYISI]<0 THEN 0 ELSE [FÝNANSMAN GÜN SAYISI] END   AS [FINANSMAN MALÝYETÝ],
[KAR - VERGÝSÝZ] - ((([ALIÞ TUTARI KDV DAHÝL] * 0.6)/365) *  CASE WHEN [FÝNANSMAN GÜN SAYISI]<0 THEN 0 ELSE [FÝNANSMAN GÜN SAYISI] END)  AS [FÝNANSMAN SONRASI KAR],
(([KAR - VERGÝSÝZ] - ((([ALIÞ TUTARI KDV DAHÝL] * 0.6)/365) *  CASE WHEN [FÝNANSMAN GÜN SAYISI]<0 THEN 0 ELSE [FÝNANSMAN GÜN SAYISI] END)) / [GÝRÝÞ MALÝYETÝ] ) * 100 AS [FÝNANSMAN SONRASI KAR %], 
[GÝRÝÞ MALÝYETÝ] * 0.02 AS [HEDEF PRÝM],     -- GÝRÝÞ MALÝYETÝNÝN %2'SÝ
[GÝRÝÞ MALÝYETÝ] * 0.015 AS [RISTURN PRÝM],  -- GÝRÝÞ MALÝYETÝNÝN %1.5'Ý
[GÝRÝÞ MALÝYETÝ] * 0.01 AS [CSI PRÝM],       -- GÝRÝÞ MALÝYETÝNÝN %1'Ý
([GÝRÝÞ MALÝYETÝ] * 0.02)   + ([GÝRÝÞ MALÝYETÝ] * 0.015) + ([GÝRÝÞ MALÝYETÝ] * 0.01) AS [TOPLAM PRÝM],
([GÝRÝÞ MALÝYETÝ] * 0.02)   + ([GÝRÝÞ MALÝYETÝ] * 0.015) + ([GÝRÝÞ MALÝYETÝ] * 0.01) + ([KAR - VERGÝSÝZ] - ((([ALIÞ TUTARI KDV DAHÝL] * 0.6)/365) *  [STOKTA BEKLEME GÜN SAYISI]))  AS [NET KAR],
((([GÝRÝÞ MALÝYETÝ] * 0.02) + ([GÝRÝÞ MALÝYETÝ] * 0.015) + ([GÝRÝÞ MALÝYETÝ] * 0.01) + ([KAR - VERGÝSÝZ] - ((([ALIÞ TUTARI KDV DAHÝL] * 0.6)/365) *  [STOKTA BEKLEME GÜN SAYISI]))) / [GÝRÝÞ MALÝYETÝ]) * 100 AS [NET KAR %]


FROM

(
SELECT
sto_sezon_kodu AS [SIFIR / 2.EL / DEMÝRBAÞ],
dbo.AREM_MusteriAdiBul(sth_stok_kod) as [MÜÞTERÝ],
dbo.AREM_MusteriVKN(sth_stok_kod) as [VKN_NO],
dbo.AREM_SatisFaturaBelgeNo(sth_stok_kod )as [BELGE NO],
dbo.AREM_TemsilciAdiBul(sth_stok_kod) as [SATIÞ DANIÞMANI], 
sth_stok_kod AS [ÞASE],
sto_isim AS [ADI],
MAX(CASE WHEN sth_tip = 0 THEN sth_tarih    ELSE '' END) AS [GÝRÝÞ TARÝHÝ],
MAX(CASE WHEN sth_tip = 0 THEN [dbo].[fn_OpVadeTarih](sth_odeme_op,sth_tarih) ELSE '' END) AS [VADE TARÝHÝ],
MAX(CASE WHEN sth_tip = 0 THEN sth_tutar    ELSE '' END) AS [ALIÞ TUTARI],
MAX(CASE WHEN sth_tip = 0 THEN sth_vergi    ELSE '' END) AS [ALIÞ KDV],          
MAX(CASE WHEN sth_tip = 0 THEN sth_tutar + sth_vergi ELSE '' END) AS [ALIÞ TUTARI KDV DAHÝL],
SUM(CASE WHEN sth_tip = 1 and sth_cins = 9 THEN sth_tutar else 0 end) as [ALIÞ ÝSKONTO],
SUM(CASE WHEN sth_tip = 1 and sth_cins = 9 THEN sth_vergi else 0 end) as [ALIÞ ÝSKONTO KDV],
 
    (select SUM(ISNULL(cha_ft_iskonto1, 0) + 
        ISNULL(cha_ft_iskonto2, 0) + 
        ISNULL(cha_ft_iskonto3, 0) + 
        ISNULL(cha_ft_iskonto4, 0) + 
        ISNULL(cha_ft_iskonto5, 0) + 
        ISNULL(cha_ft_iskonto6, 0)) AS ToplamIskonto
	FROM CARI_HESAP_HAREKETLERI
	WHERE cha_belge_no = dbo.AREM_SatisFaturaBelgeNo(sth_stok_kod)) as [SATIÞ ÝSKONTO],
SUM(CASE WHEN sth_tip = 0 and sth_cins = 9 THEN sth_vergi else 0 end) as [SATIÞ ÝSKONTO KDV],

(MAX(CASE WHEN sth_tip = 0 THEN sth_tutar ELSE '' END) - SUM(CASE WHEN sth_tip = 1 and sth_cins = 9 THEN sth_tutar else 0 end)) + SUM(CASE WHEN sth_tip = 0 and sth_cins = 9 THEN sth_tutar else 0 end) as [GÝRÝÞ MALÝYETÝ],
MAX(CASE WHEN sth_tip = 1 and sth_cins <> 9 THEN sth_tarih ELSE '' END) AS [SATIÞ TARÝHÝ],
(
	SELECT 
		SUM(cha_aratoplam) - 
		SUM(ISNULL(cha_ft_iskonto1, 0) + 
		    ISNULL(cha_ft_iskonto2, 0) + 
		    ISNULL(cha_ft_iskonto3, 0) + 
		    ISNULL(cha_ft_iskonto4, 0) + 
		    ISNULL(cha_ft_iskonto5, 0) + 
		    ISNULL(cha_ft_iskonto6, 0))
	FROM CARI_HESAP_HAREKETLERI
	WHERE cha_belge_no = dbo.AREM_SatisFaturaBelgeNo(sth_stok_kod)
) AS [SATIÞ TUTARI],
(
	SELECT SUM(cha_otvtutari)
	FROM CARI_HESAP_HAREKETLERI
	WHERE cha_belge_no = dbo.AREM_SatisFaturaBelgeNo(sth_stok_kod)
)  AS [SATIÞ ÖTV],
(
	SELECT SUM(cha_kdv_toplam)
	FROM CARI_HESAP_HAREKETLERI
	WHERE cha_belge_no = dbo.AREM_SatisFaturaBelgeNo(sth_stok_kod)
) AS [SATIÞ KDV],
(
	SELECT SUM(cha_meblag)
	FROM CARI_HESAP_HAREKETLERI
	WHERE cha_belge_no = dbo.AREM_SatisFaturaBelgeNo(sth_stok_kod)
) AS [SATIÞ VERGÝLER DAHÝL],
(
	SELECT 
		SUM(cha_aratoplam) - 
		SUM(ISNULL(cha_ft_iskonto1, 0) + 
		    ISNULL(cha_ft_iskonto2, 0) + 
		    ISNULL(cha_ft_iskonto3, 0) + 
		    ISNULL(cha_ft_iskonto4, 0) + 
		    ISNULL(cha_ft_iskonto5, 0) + 
		    ISNULL(cha_ft_iskonto6, 0))
	FROM CARI_HESAP_HAREKETLERI
	WHERE cha_belge_no = dbo.AREM_SatisFaturaBelgeNo(sth_stok_kod)
) - (MAX(CASE WHEN sth_tip = 0 THEN sth_tutar ELSE '' END) - SUM(CASE WHEN sth_tip = 1 and sth_cins = 9 THEN sth_tutar else 0 end)) AS [KAR - VERGÝSÝZ],
DATEDIFF(DAY,MAX(CASE WHEN sth_tip = 0 THEN sth_tarih ELSE '' END),MAX(CASE WHEN sth_tip = 1 THEN sth_tarih ELSE '' END)) AS [STOKTA BEKLEME GÜN SAYISI],
DATEDIFF(DAY,MAX(CASE WHEN sth_tip = 0 THEN [dbo].[fn_OpVadeTarih](sth_odeme_op,sth_tarih) ELSE '' END),MAX(CASE WHEN sth_tip = 1 THEN sth_tarih ELSE '' END)) AS [FÝNANSMAN GÜN SAYISI]


FROM STOK_HAREKETLERI WITH(NOLOCK)
LEFT JOIN STOKLAR ON sto_kod = sth_stok_kod
WHERE sto_anagrup_kod in ('001','1')
GROUP BY sth_stok_kod,sto_isim,sto_sezon_kodu


UNION ALL 

SELECT 

'DEMÝRBAÞ' AS [SIFIR / 2.EL / DEMÝRBAÞ],
dbo.AREM_MusteriAdiBul_Demirbas(dem_kod) as [MÜÞTERÝ],
dbo.AREM_MusteriVKN_Demirbas(dem_kod) as [VKN_NO],
dbo.AREM_SatisBelgeNo_Demirbas(dem_kod )as [BELGE NO],
dbo.AREM_TemsilciAdiBul_Demirbas(dem_kod)  as [TEMÝSLCÝ], 
MAX(dem_kod) AS [ÞASE],
MAX(dem_isim) AS [ADI],
--dem_fatura_seri + '-' + convert(nvarchar(50),dem_fatura_sira),
dem_fatura_tarihi AS [GÝRÝÞ TARÝHÝ],
'' as [VADE TARÝHÝ], 
MAX(dem_tutar) AS [ALIÞ TUTARI], 
MAX(dem_tutar * dbo.fn_VergiYuzde(dem_vergi))/100 AS [ALIÞ KDV], 
MAX(dem_tutar + ((dem_tutar * dbo.fn_VergiYuzde(dem_vergi)))/100) AS [ALIÞ TUTARI KDV DAHÝL], 
'' as [ALIÞ ÝSKONTO],
'' as [ALIÞ ÝSKONTO KDV],
'' as [SATIÞ ÝSKONTO],
'' as [SATIÞ ÝSKONTO KDV],

MAX(dem_tutar)as [GÝRÝÞ MALÝYETÝ], 
MAX(case when cha_evrak_tip = 63 then cha_tarihi end) AS [SATIÞ TARÝHÝ],
SUM(CASE WHEN cha_evrak_tip = 63 then cha_aratoplam end) AS [SATIÞ TUTARI],
'' AS [SATIÞ ÖTV],
SUM(CASE WHEN cha_evrak_tip=63 then cha_vergi1+cha_vergi2+cha_vergi3+cha_vergi4 end) AS [SATIÞ KDV],
SUM(CASE WHEN cha_evrak_tip=63 then cha_meblag  end) AS [SATIÞ VERGÝLER DAHÝL],
SUM(CASE WHEN cha_evrak_tip = 63 then cha_aratoplam end) - MAX(dem_tutar) AS [KAR - VERGÝSÝZ], 
MAX(DATEDIFF(DAY,dem_fatura_tarihi,getdate())) AS [STOKTA BEKLEME GÜN SAYISI],
MAX(DATEDIFF(DAY,[dbo].[fn_OpVadeTarih](cha_vade,dem_fatura_tarihi),getdate())) AS [FÝNANSMAN GÜN SAYISI]




FROM DEMIRBASLAR 
LEFT OUTER JOIN CARI_HESAP_HAREKETLERI WITH(NOLOCK) ON cha_kasa_hizkod = dem_kod 
WHERE dem_muh_kodu like '254%' 
and dbo.fn_AtikEldekiMiktar(dem_kod,2020) = 0 
--and cha_tarihi BETWEEN '20200101' AND '20200831'
GROUP BY dem_fatura_sira,dem_fatura_tarihi,dem_kod

) ARAC_SATIS
WHERE [SATIÞ TUTARI] > 0 
AND [SATIÞ TARÝHÝ] BETWEEN @ILKTARIH AND @SONTARIH
--ORDER BY [SATIÞ TARÝHÝ]

-------------------------------------- SIFIR --------------------------------------------------------------

UNION ALL

SELECT 
'SIFIR ORTALAMA',
'',
'',
'',
'',
'',
'',
'',
'',
'',
'',
COUNT([ALIÞ TUTARI]),
'',
'',
'',
'',
'',
'',
'',
'',
'',
'',
SUM([KAR - VERGÝSÝZ]) / COUNT([ALIÞ TUTARI]),
(SUM([KAR - VERGÝSÝZ] / [GÝRÝÞ MALÝYETÝ])) / COUNT([ALIÞ TUTARI]) * 100,
SUM([STOKTA BEKLEME GÜN SAYISI]) / COUNT([ALIÞ TUTARI]),
SUM([FÝNANSMAN GÜN SAYISI]) / COUNT([ALIÞ TUTARI]),
SUM([KAR - VERGÝSÝZ]) / COUNT([ALIÞ TUTARI]),
'ORTALAMA KAR' =  SUM([KAR - VERGÝSÝZ]) / SUM([GÝRÝÞ MALÝYETÝ]) * 100 ,
'',
'',
'',
'',
'',
SUM([NET KAR]) / COUNT([ALIÞ TUTARI]) ,
(SUM([NET KAR]) / SUM([GÝRÝÞ MALÝYETÝ])) * 100
FROM 

(

SELECT 
*,
(([ALIÞ TUTARI KDV DAHÝL] * 0.6)/365) *  [STOKTA BEKLEME GÜN SAYISI]   AS [FINANSMAN MALÝYETÝ],
[KAR - VERGÝSÝZ] - ((([ALIÞ TUTARI KDV DAHÝL] * 0.6)/365) *  [STOKTA BEKLEME GÜN SAYISI])  AS [NET KAR]
FROM

(
SELECT
sto_sezon_kodu AS [SIFIR / 2.EL / DEMÝRBAÞ],
dbo.AREM_MusteriAdiBul(sth_stok_kod) as [MÜÞTERÝ],
dbo.AREM_MusteriVKN(sth_stok_kod) as [VKN_NO],
dbo.AREM_SatisFaturaBelgeNo(sth_stok_kod )as [BELGE NO],
dbo.AREM_TemsilciAdiBul(sth_stok_kod) as [TEMÝSLCÝ], 
sth_stok_kod AS [ÞASE],
sto_isim AS [ADI],
MAX(CASE WHEN sth_tip = 0 THEN sth_tarih ELSE '' END) AS [GÝRÝÞ TARÝHÝ],
MAX(CASE WHEN sth_tip = 0 THEN sth_tutar ELSE '' END) AS [ALIÞ TUTARI],
MAX(CASE WHEN sth_tip = 0 THEN sth_vergi ELSE '' END) AS [ALIÞ KDV],
MAX(CASE WHEN sth_tip = 0 THEN sth_tutar + sth_vergi ELSE '' END) AS [ALIÞ TUTARI KDV DAHÝL],
SUM(CASE WHEN sth_tip = 1 and sth_cins = 9 THEN sth_tutar else 0 end) as [ALIÞ ÝSKONTO],
SUM(CASE WHEN sth_tip = 1 and sth_cins = 9 THEN sth_vergi else 0 end) as [ALIÞ ÝSKONTO KDV],
  (select SUM(ISNULL(cha_ft_iskonto1, 0) + 
        ISNULL(cha_ft_iskonto2, 0) + 
        ISNULL(cha_ft_iskonto3, 0) + 
        ISNULL(cha_ft_iskonto4, 0) + 
        ISNULL(cha_ft_iskonto5, 0) + 
        ISNULL(cha_ft_iskonto6, 0)) AS ToplamIskonto
	FROM CARI_HESAP_HAREKETLERI
	WHERE cha_belge_no = dbo.AREM_SatisFaturaBelgeNo(sth_stok_kod)) as [SATIÞ ÝSKONTO],
SUM(CASE WHEN sth_tip = 0 and sth_cins = 9 THEN sth_vergi else 0 end) as [SATIÞ ÝSKONTO KDV],

MAX(CASE WHEN sth_tip = 0 THEN sth_tutar ELSE '' END) - SUM(CASE WHEN sth_tip = 1 and sth_cins = 9 THEN sth_tutar else 0 end) as [GÝRÝÞ MALÝYETÝ],
MAX(CASE WHEN sth_tip = 1 and sth_cins <> 9 THEN sth_tarih ELSE '' END) AS [SATIÞ TARÝHÝ],
(
	SELECT 
		SUM(cha_aratoplam) - 
		SUM(ISNULL(cha_ft_iskonto1, 0) + 
		    ISNULL(cha_ft_iskonto2, 0) + 
		    ISNULL(cha_ft_iskonto3, 0) + 
		    ISNULL(cha_ft_iskonto4, 0) + 
		    ISNULL(cha_ft_iskonto5, 0) + 
		    ISNULL(cha_ft_iskonto6, 0))
	FROM CARI_HESAP_HAREKETLERI
	WHERE cha_belge_no = dbo.AREM_SatisFaturaBelgeNo(sth_stok_kod)
)AS [SATIÞ TUTARI],
(
	SELECT SUM(cha_otvtutari)
	FROM CARI_HESAP_HAREKETLERI
	WHERE cha_belge_no = dbo.AREM_SatisFaturaBelgeNo(sth_stok_kod)
)  AS [SATIÞ ÖTV],
(
	SELECT SUM(cha_kdv_toplam)
	FROM CARI_HESAP_HAREKETLERI
	WHERE cha_belge_no = dbo.AREM_SatisFaturaBelgeNo(sth_stok_kod)
) AS [SATIÞ KDV],
(
	SELECT SUM(cha_meblag)
	FROM CARI_HESAP_HAREKETLERI
	WHERE cha_belge_no = dbo.AREM_SatisFaturaBelgeNo(sth_stok_kod)
) AS [SATIÞ VERGÝLER DAHÝL],
(
SELECT 
		SUM(cha_aratoplam) - 
		SUM(ISNULL(cha_ft_iskonto1, 0) + 
		    ISNULL(cha_ft_iskonto2, 0) + 
		    ISNULL(cha_ft_iskonto3, 0) + 
		    ISNULL(cha_ft_iskonto4, 0) + 
		    ISNULL(cha_ft_iskonto5, 0) + 
		    ISNULL(cha_ft_iskonto6, 0))
	FROM CARI_HESAP_HAREKETLERI
	WHERE cha_belge_no = dbo.AREM_SatisFaturaBelgeNo(sth_stok_kod)
) - (MAX(CASE WHEN sth_tip = 0 THEN sth_tutar ELSE '' END) - SUM(CASE WHEN sth_tip = 1 and sth_cins = 9 THEN sth_tutar else 0 end)) AS [KAR - VERGÝSÝZ],
DATEDIFF(DAY,MAX(CASE WHEN sth_tip = 0 THEN sth_tarih ELSE '' END),MAX(CASE WHEN sth_tip = 1 THEN sth_tarih ELSE '' END)) AS [STOKTA BEKLEME GÜN SAYISI],
DATEDIFF(DAY,MAX(CASE WHEN sth_tip = 0 THEN [dbo].[fn_OpVadeTarih](sth_odeme_op,sth_tarih) ELSE '' END),MAX(CASE WHEN sth_tip = 1 THEN [dbo].[fn_OpVadeTarih](sth_odeme_op,sth_tarih) ELSE '' END)) AS [FÝNANSMAN GÜN SAYISI]

FROM STOK_HAREKETLERI WITH(NOLOCK)
LEFT JOIN STOKLAR ON sto_kod = sth_stok_kod
WHERE sto_anagrup_kod = 'ARAÇ'

GROUP BY sth_stok_kod,sto_isim,sto_sezon_kodu

) ARAC_SATIS
WHERE [SATIÞ TUTARI] > 0 
AND [SATIÞ TARÝHÝ] BETWEEN @ILKTARIH AND @SONTARIH
AND [SIFIR / 2.EL / DEMÝRBAÞ] = 'SIFIR'
--ORDER BY [SATIÞ TARÝHÝ]
) FORMUL
GROUP BY [SIFIR / 2.EL / DEMÝRBAÞ]

---------------------------------------- 2.EL --------------------------------------------------------------

UNION ALL



SELECT 
'2.EL ORTALAMA',
'',
'',
'',
'',
'',
'',
'',
'',
'',
'',
COUNT([ALIÞ TUTARI]),
'',
'',
'',
'',
'',
'',
'',
'',
'',
'',
SUM([KAR - VERGÝSÝZ]) / COUNT([ALIÞ TUTARI]),
(SUM([KAR - VERGÝSÝZ]) / SUM([GÝRÝÞ MALÝYETÝ])) / COUNT([ALIÞ TUTARI]) * 100,
SUM([STOKTA BEKLEME GÜN SAYISI]) / COUNT([ALIÞ TUTARI]),
SUM([FÝNANSMAN GÜN SAYISI]) / COUNT([ALIÞ TUTARI]),
SUM([KAR - VERGÝSÝZ]) / COUNT([ALIÞ TUTARI]),
'ORTALAMA KAR' =  SUM([KAR - VERGÝSÝZ]) / SUM([GÝRÝÞ MALÝYETÝ]) * 100 ,
'',
'',
'',
'',
'',
SUM([NET KAR]) / COUNT([ALIÞ TUTARI]) ,
(SUM([NET KAR]) / SUM([GÝRÝÞ MALÝYETÝ])) * 100
FROM 

(

SELECT 
*,
(([ALIÞ TUTARI KDV DAHÝL] * 0.6)/365) *  [STOKTA BEKLEME GÜN SAYISI]   AS [FINANSMAN MALÝYETÝ],
[KAR - VERGÝSÝZ] - ((([ALIÞ TUTARI KDV DAHÝL] * 0.6)/365) *  [STOKTA BEKLEME GÜN SAYISI])  AS [NET KAR]
FROM

(
SELECT
sto_sezon_kodu AS [SIFIR / 2.EL / DEMÝRBAÞ],
dbo.AREM_MusteriAdiBul(sth_stok_kod) as [MÜÞTERÝ],
dbo.AREM_MusteriVKN(sth_stok_kod) as [VKN_NO],
dbo.AREM_SatisFaturaBelgeNo(sth_stok_kod )as [BELGE NO],
dbo.AREM_TemsilciAdiBul(sth_stok_kod) as [TEMÝSLCÝ], 
sth_stok_kod AS [ÞASE],
sto_isim AS [ADI],
MAX(CASE WHEN sth_tip = 0 THEN sth_tarih ELSE '' END) AS [GÝRÝÞ TARÝHÝ],
MAX(CASE WHEN sth_tip = 0 THEN sth_tutar ELSE '' END) AS [ALIÞ TUTARI],
MAX(CASE WHEN sth_tip = 0 THEN sth_vergi ELSE '' END) AS [ALIÞ KDV],
MAX(CASE WHEN sth_tip = 0 THEN sth_tutar + sth_vergi ELSE '' END) AS [ALIÞ TUTARI KDV DAHÝL],
SUM(CASE WHEN sth_tip = 1 and sth_cins = 9 THEN sth_tutar else 0 end) as [ALIÞ ÝSKONTO],
SUM(CASE WHEN sth_tip = 1 and sth_cins = 9 THEN sth_vergi else 0 end) as [ALIÞ ÝSKONTO KDV],
  (select SUM(ISNULL(cha_ft_iskonto1, 0) + 
        ISNULL(cha_ft_iskonto2, 0) + 
        ISNULL(cha_ft_iskonto3, 0) + 
        ISNULL(cha_ft_iskonto4, 0) + 
        ISNULL(cha_ft_iskonto5, 0) + 
        ISNULL(cha_ft_iskonto6, 0)) AS ToplamIskonto
	FROM CARI_HESAP_HAREKETLERI
	WHERE cha_belge_no = dbo.AREM_SatisFaturaBelgeNo(sth_stok_kod)) as [SATIÞ ÝSKONTO],
SUM(CASE WHEN sth_tip = 0 and sth_cins = 9 THEN sth_vergi else 0 end) as [SATIÞ ÝSKONTO KDV],

MAX(CASE WHEN sth_tip = 0 THEN sth_tutar ELSE '' END) - SUM(CASE WHEN sth_tip = 1 and sth_cins = 9 THEN sth_tutar else 0 end) as [GÝRÝÞ MALÝYETÝ],
MAX(CASE WHEN sth_tip = 1 and sth_cins <> 9 THEN sth_tarih ELSE '' END) AS [SATIÞ TARÝHÝ],
(
	SELECT 
		SUM(cha_aratoplam) - 
		SUM(ISNULL(cha_ft_iskonto1, 0) + 
		    ISNULL(cha_ft_iskonto2, 0) + 
		    ISNULL(cha_ft_iskonto3, 0) + 
		    ISNULL(cha_ft_iskonto4, 0) + 
		    ISNULL(cha_ft_iskonto5, 0) + 
		    ISNULL(cha_ft_iskonto6, 0))
	FROM CARI_HESAP_HAREKETLERI
	WHERE cha_belge_no = dbo.AREM_SatisFaturaBelgeNo(sth_stok_kod)
) AS [SATIÞ TUTARI],
(
	SELECT SUM(cha_otvtutari)
	FROM CARI_HESAP_HAREKETLERI
	WHERE cha_belge_no = dbo.AREM_SatisFaturaBelgeNo(sth_stok_kod)
)  AS [SATIÞ ÖTV],
(
	SELECT SUM(cha_kdv_toplam)
	FROM CARI_HESAP_HAREKETLERI
	WHERE cha_belge_no = dbo.AREM_SatisFaturaBelgeNo(sth_stok_kod)
) AS [SATIÞ KDV],
(
	SELECT SUM(cha_meblag)
	FROM CARI_HESAP_HAREKETLERI
	WHERE cha_belge_no = dbo.AREM_SatisFaturaBelgeNo(sth_stok_kod)
) AS [SATIÞ VERGÝLER DAHÝL],
(
	SELECT 
		SUM(cha_aratoplam) - 
		SUM(ISNULL(cha_ft_iskonto1, 0) + 
		    ISNULL(cha_ft_iskonto2, 0) + 
		    ISNULL(cha_ft_iskonto3, 0) + 
		    ISNULL(cha_ft_iskonto4, 0) + 
		    ISNULL(cha_ft_iskonto5, 0) + 
		    ISNULL(cha_ft_iskonto6, 0))
	FROM CARI_HESAP_HAREKETLERI
	WHERE cha_belge_no = dbo.AREM_SatisFaturaBelgeNo(sth_stok_kod)
) - (MAX(CASE WHEN sth_tip = 0 THEN sth_tutar ELSE '' END) - SUM(CASE WHEN sth_tip = 1 and sth_cins = 9 THEN sth_tutar else 0 end)) AS [KAR - VERGÝSÝZ],
DATEDIFF(DAY,MAX(CASE WHEN sth_tip = 0 THEN sth_tarih ELSE '' END),MAX(CASE WHEN sth_tip = 1 THEN sth_tarih ELSE '' END)) AS [STOKTA BEKLEME GÜN SAYISI],
DATEDIFF(DAY,MAX(CASE WHEN sth_tip = 0 THEN [dbo].[fn_OpVadeTarih](sth_odeme_op,sth_tarih) ELSE '' END),MAX(CASE WHEN sth_tip = 1 THEN [dbo].[fn_OpVadeTarih](sth_odeme_op,sth_tarih) ELSE '' END)) AS [FÝNANSMAN GÜN SAYISI]

FROM STOK_HAREKETLERI WITH(NOLOCK)
LEFT JOIN STOKLAR ON sto_kod = sth_stok_kod
WHERE sto_anagrup_kod = 'ARAÇ'
GROUP BY sth_stok_kod,sto_isim,sto_sezon_kodu

) ARAC_SATIS
WHERE [SATIÞ TUTARI] > 0 
AND [SATIÞ TARÝHÝ] BETWEEN @ILKTARIH AND @SONTARIH
AND [SIFIR / 2.EL / DEMÝRBAÞ] = '2.EL'
--ORDER BY [SATIÞ TARÝHÝ]
) FORMUL
GROUP BY [SIFIR / 2.EL / DEMÝRBAÞ]


-------------------------------------- DEMÝRBAÞ ---------------------------


UNION ALL



SELECT 
'DEMÝRBAÞ ORTALAMA',
'',
'',
'',
'',
'',
'',
'',
'',
'',
'',
COUNT([ALIÞ TUTARI]),
'',
'',
'',
'',
'',
'',
'',
'',
'',
'',
SUM([KAR - VERGÝSÝZ]) / COUNT([ALIÞ TUTARI]),
(SUM([KAR - VERGÝSÝZ]) / SUM([GÝRÝÞ MALÝYETÝ])) / COUNT([ALIÞ TUTARI]) * 100,
SUM([STOKTA BEKLEME GÜN SAYISI]) / COUNT([ALIÞ TUTARI]),
SUM([FÝNANSMAN GÜN SAYISI]) / COUNT([ALIÞ TUTARI]),
SUM([KAR - VERGÝSÝZ]) / COUNT([ALIÞ TUTARI]) ,
SUM([KAR - VERGÝSÝZ]) / SUM([GÝRÝÞ MALÝYETÝ]) * 100,
'',
'',
'',
'',
'',
SUM([NET KAR]) / COUNT([ALIÞ TUTARI]) ,
(SUM([NET KAR]) / SUM([GÝRÝÞ MALÝYETÝ])) * 100
FROM 

(

SELECT 
*,
(([ALIÞ TUTARI KDV DAHÝL] * 0.6)/365) *  [STOKTA BEKLEME GÜN SAYISI]   AS [FINANSMAN MALÝYETÝ],
[KAR - VERGÝSÝZ] - ((([ALIÞ TUTARI KDV DAHÝL] * 0.6)/365) *  [STOKTA BEKLEME GÜN SAYISI])  AS [NET KAR]
FROM

(
SELECT 

'DEMÝRBAÞ' AS [SIFIR / 2.EL / DEMÝRBAÞ],
dbo.AREM_MusteriAdiBul_Demirbas(dem_kod) as [MÜÞTERÝ],
dbo.AREM_MusteriVKN_Demirbas(dem_kod) as [VKN_NO],
dbo.AREM_SatisBelgeNo_Demirbas(dem_kod )as [BELGE NO],
dbo.AREM_TemsilciAdiBul_Demirbas(dem_kod)  as [TEMÝSLCÝ], 
MAX(dem_kod) AS [ÞASE],
MAX(dem_isim) AS [ADI],
--dem_fatura_seri + '-' + convert(nvarchar(50),dem_fatura_sira),
dem_fatura_tarihi AS [GÝRÝÞ TARÝHÝ],
MAX(dem_tutar) AS [ALIÞ TUTARI], 
MAX(dem_tutar * dbo.fn_VergiYuzde(dem_vergi))/100 AS [ALIÞ KDV], 
MAX(dem_tutar + ((dem_tutar * dbo.fn_VergiYuzde(dem_vergi)))/100) AS [ALIÞ TUTARI KDV DAHÝL], 
'' as [ALIÞ ÝSKONTO],
'' as [ALIÞ ÝSKONTO KDV],
'' as [SATIÞ ÝSKONTO],
'' as [SATIÞ ÝSKONTO KDV],

MAX(dem_tutar)as [GÝRÝÞ MALÝYETÝ], 
MAX(case when cha_evrak_tip = 63 then cha_tarihi end) AS [SATIÞ TARÝHÝ],
SUM(CASE WHEN cha_evrak_tip = 63 then cha_aratoplam end) AS [SATIÞ TUTARI],
'' AS [SATIÞ ÖTV],
SUM(CASE WHEN cha_evrak_tip=63 then cha_vergi1+cha_vergi2+cha_vergi3+cha_vergi4 end) AS [SATIÞ KDV],
SUM(CASE WHEN cha_evrak_tip=63 then cha_meblag  end) AS [SATIÞ VERGÝLER DAHÝL],
SUM(CASE WHEN cha_evrak_tip = 63 then cha_aratoplam end) - MAX(dem_tutar) AS [KAR - VERGÝSÝZ], 
MAX(DATEDIFF(DAY,dem_fatura_tarihi,getdate())) AS [STOKTA BEKLEME GÜN SAYISI],
MAX(DATEDIFF(DAY,[dbo].[fn_OpVadeTarih](cha_vade,dem_fatura_tarihi),getdate())) AS [FÝNANSMAN GÜN SAYISI]


FROM DEMIRBASLAR 
LEFT OUTER JOIN CARI_HESAP_HAREKETLERI WITH(NOLOCK) ON cha_kasa_hizkod = dem_kod 
WHERE dem_muh_kodu like '254%' 
and dbo.fn_AtikEldekiMiktar(dem_kod,2020) = 0 
--and cha_tarihi BETWEEN '20200101' AND '20200831'
GROUP BY dem_fatura_sira,dem_fatura_tarihi,dem_kod

) ARAC_SATIS
WHERE [SATIÞ TUTARI] > 0 
AND [SATIÞ TARÝHÝ] BETWEEN @ILKTARIH AND @SONTARIH
AND [SIFIR / 2.EL / DEMÝRBAÞ] = 'DEMÝRBAÞ'
--ORDER BY [SATIÞ TARÝHÝ]
) FORMUL
GROUP BY [SIFIR / 2.EL / DEMÝRBAÞ]

