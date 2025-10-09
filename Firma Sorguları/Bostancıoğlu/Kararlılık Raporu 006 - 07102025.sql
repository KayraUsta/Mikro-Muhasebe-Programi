[<
	<@H;@P1 -  @P2 / ARA� SATI� RAPORU - BOSTANCIO�LU OTOMOT�V>
	<@P1;NAME=Ba�lang�� tarihi,10;TYPE=T>
	<@P2;NAME=Biti� tarihi,10;TYPE=T>
>]
--- 001
DECLARE @ILKTARIH AS DATE       
DECLARE @SONTARIH AS DATE 
SET     @ILKTARIH = @P1
SET     @SONTARIH = @P2


SELECT 
[SIFIR / 2.EL / DEM�RBA�],
[M��TER�],
[VKN_NO],
[BELGE NO],
[SATI� DANI�MANI],
[�ASE],
[ADI],
ISNULL([G�R�� TAR�H�],'') AS [G�R�� TAR�H�],
[VADE TAR�H�],
[ALI� TUTARI],
[ALI� KDV],
[ALI� TUTARI KDV DAH�L],
[ALI� �SKONTO],
[ALI� �SKONTO KDV],
[SATI� �SKONTO],
[SATI� �SKONTO KDV],
[G�R�� MAL�YET�],
[SATI� TAR�H�],
[SATI� TUTARI],
[SATI� �TV],
[SATI� KDV],
[SATI� VERG�LER DAH�L],
[KAR - VERG�S�Z],
([KAR - VERG�S�Z] / [G�R�� MAL�YET�]) * 100 AS [VERG�S�Z KAR %],
[STOKTA BEKLEME G�N SAYISI],
[F�NANSMAN G�N SAYISI] AS [F�NANSMAN G�N SAYISI],
(([ALI� TUTARI KDV DAH�L] * 0.6)/365) *  CASE WHEN [F�NANSMAN G�N SAYISI]<0 THEN 0 ELSE [F�NANSMAN G�N SAYISI] END   AS [FINANSMAN MAL�YET�],
[KAR - VERG�S�Z] - ((([ALI� TUTARI KDV DAH�L] * 0.6)/365) *  CASE WHEN [F�NANSMAN G�N SAYISI]<0 THEN 0 ELSE [F�NANSMAN G�N SAYISI] END)  AS [F�NANSMAN SONRASI KAR],
(([KAR - VERG�S�Z] - ((([ALI� TUTARI KDV DAH�L] * 0.6)/365) *  CASE WHEN [F�NANSMAN G�N SAYISI]<0 THEN 0 ELSE [F�NANSMAN G�N SAYISI] END)) / [G�R�� MAL�YET�] ) * 100 AS [F�NANSMAN SONRASI KAR %], 
[G�R�� MAL�YET�] * 0.02 AS [HEDEF PR�M],     -- G�R�� MAL�YET�N�N %2'S�
[G�R�� MAL�YET�] * 0.015 AS [RISTURN PR�M],  -- G�R�� MAL�YET�N�N %1.5'�
[G�R�� MAL�YET�] * 0.01 AS [CSI PR�M],       -- G�R�� MAL�YET�N�N %1'�
([G�R�� MAL�YET�] * 0.02)   + ([G�R�� MAL�YET�] * 0.015) + ([G�R�� MAL�YET�] * 0.01) AS [TOPLAM PR�M],
([G�R�� MAL�YET�] * 0.02)   + ([G�R�� MAL�YET�] * 0.015) + ([G�R�� MAL�YET�] * 0.01) + ([KAR - VERG�S�Z] - ((([ALI� TUTARI KDV DAH�L] * 0.6)/365) *  [STOKTA BEKLEME G�N SAYISI]))  AS [NET KAR],
((([G�R�� MAL�YET�] * 0.02) + ([G�R�� MAL�YET�] * 0.015) + ([G�R�� MAL�YET�] * 0.01) + ([KAR - VERG�S�Z] - ((([ALI� TUTARI KDV DAH�L] * 0.6)/365) *  [STOKTA BEKLEME G�N SAYISI]))) / [G�R�� MAL�YET�]) * 100 AS [NET KAR %]


FROM

(
SELECT
sto_sezon_kodu AS [SIFIR / 2.EL / DEM�RBA�],
dbo.AREM_MusteriAdiBul(sth_stok_kod) as [M��TER�],
dbo.AREM_MusteriVKN(sth_stok_kod) as [VKN_NO],
dbo.AREM_SatisFaturaBelgeNo(sth_stok_kod )as [BELGE NO],
dbo.AREM_TemsilciAdiBul(sth_stok_kod) as [SATI� DANI�MANI], 
sth_stok_kod AS [�ASE],
sto_isim AS [ADI],
MAX(CASE WHEN sth_tip = 0 THEN sth_tarih    ELSE '' END) AS [G�R�� TAR�H�],
MAX(CASE WHEN sth_tip = 0 THEN [dbo].[fn_OpVadeTarih](sth_odeme_op,sth_tarih) ELSE '' END) AS [VADE TAR�H�],
MAX(CASE WHEN sth_tip = 0 THEN sth_tutar    ELSE '' END) AS [ALI� TUTARI],
MAX(CASE WHEN sth_tip = 0 THEN sth_vergi    ELSE '' END) AS [ALI� KDV],          
MAX(CASE WHEN sth_tip = 0 THEN sth_tutar + sth_vergi ELSE '' END) AS [ALI� TUTARI KDV DAH�L],
SUM(CASE WHEN sth_tip = 1 and sth_cins = 9 THEN sth_tutar else 0 end) as [ALI� �SKONTO],
SUM(CASE WHEN sth_tip = 1 and sth_cins = 9 THEN sth_vergi else 0 end) as [ALI� �SKONTO KDV],
 
    (select SUM(ISNULL(cha_ft_iskonto1, 0) + 
        ISNULL(cha_ft_iskonto2, 0) + 
        ISNULL(cha_ft_iskonto3, 0) + 
        ISNULL(cha_ft_iskonto4, 0) + 
        ISNULL(cha_ft_iskonto5, 0) + 
        ISNULL(cha_ft_iskonto6, 0)) AS ToplamIskonto
	FROM CARI_HESAP_HAREKETLERI
	WHERE cha_belge_no = dbo.AREM_SatisFaturaBelgeNo(sth_stok_kod)) as [SATI� �SKONTO],
SUM(CASE WHEN sth_tip = 0 and sth_cins = 9 THEN sth_vergi else 0 end) as [SATI� �SKONTO KDV],

(MAX(CASE WHEN sth_tip = 0 THEN sth_tutar ELSE '' END) - SUM(CASE WHEN sth_tip = 1 and sth_cins = 9 THEN sth_tutar else 0 end)) + SUM(CASE WHEN sth_tip = 0 and sth_cins = 9 THEN sth_tutar else 0 end) as [G�R�� MAL�YET�],
MAX(CASE WHEN sth_tip = 1 and sth_cins <> 9 THEN sth_tarih ELSE '' END) AS [SATI� TAR�H�],
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
) AS [SATI� TUTARI],
(
	SELECT SUM(cha_otvtutari)
	FROM CARI_HESAP_HAREKETLERI
	WHERE cha_belge_no = dbo.AREM_SatisFaturaBelgeNo(sth_stok_kod)
)  AS [SATI� �TV],
(
	SELECT SUM(cha_kdv_toplam)
	FROM CARI_HESAP_HAREKETLERI
	WHERE cha_belge_no = dbo.AREM_SatisFaturaBelgeNo(sth_stok_kod)
) AS [SATI� KDV],
(
	SELECT SUM(cha_meblag)
	FROM CARI_HESAP_HAREKETLERI
	WHERE cha_belge_no = dbo.AREM_SatisFaturaBelgeNo(sth_stok_kod)
) AS [SATI� VERG�LER DAH�L],
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
) - (MAX(CASE WHEN sth_tip = 0 THEN sth_tutar ELSE '' END) - SUM(CASE WHEN sth_tip = 1 and sth_cins = 9 THEN sth_tutar else 0 end)) AS [KAR - VERG�S�Z],
DATEDIFF(DAY,MAX(CASE WHEN sth_tip = 0 THEN sth_tarih ELSE '' END),MAX(CASE WHEN sth_tip = 1 THEN sth_tarih ELSE '' END)) AS [STOKTA BEKLEME G�N SAYISI],
DATEDIFF(DAY,MAX(CASE WHEN sth_tip = 0 THEN [dbo].[fn_OpVadeTarih](sth_odeme_op,sth_tarih) ELSE '' END),MAX(CASE WHEN sth_tip = 1 THEN sth_tarih ELSE '' END)) AS [F�NANSMAN G�N SAYISI]


FROM STOK_HAREKETLERI WITH(NOLOCK)
LEFT JOIN STOKLAR ON sto_kod = sth_stok_kod
WHERE sto_anagrup_kod in ('001','1')
GROUP BY sth_stok_kod,sto_isim,sto_sezon_kodu


UNION ALL 

SELECT 

'DEM�RBA�' AS [SIFIR / 2.EL / DEM�RBA�],
dbo.AREM_MusteriAdiBul_Demirbas(dem_kod) as [M��TER�],
dbo.AREM_MusteriVKN_Demirbas(dem_kod) as [VKN_NO],
dbo.AREM_SatisBelgeNo_Demirbas(dem_kod )as [BELGE NO],
dbo.AREM_TemsilciAdiBul_Demirbas(dem_kod)  as [TEM�SLC�], 
MAX(dem_kod) AS [�ASE],
MAX(dem_isim) AS [ADI],
--dem_fatura_seri + '-' + convert(nvarchar(50),dem_fatura_sira),
dem_fatura_tarihi AS [G�R�� TAR�H�],
'' as [VADE TAR�H�], 
MAX(dem_tutar) AS [ALI� TUTARI], 
MAX(dem_tutar * dbo.fn_VergiYuzde(dem_vergi))/100 AS [ALI� KDV], 
MAX(dem_tutar + ((dem_tutar * dbo.fn_VergiYuzde(dem_vergi)))/100) AS [ALI� TUTARI KDV DAH�L], 
'' as [ALI� �SKONTO],
'' as [ALI� �SKONTO KDV],
'' as [SATI� �SKONTO],
'' as [SATI� �SKONTO KDV],

MAX(dem_tutar)as [G�R�� MAL�YET�], 
MAX(case when cha_evrak_tip = 63 then cha_tarihi end) AS [SATI� TAR�H�],
SUM(CASE WHEN cha_evrak_tip = 63 then cha_aratoplam end) AS [SATI� TUTARI],
'' AS [SATI� �TV],
SUM(CASE WHEN cha_evrak_tip=63 then cha_vergi1+cha_vergi2+cha_vergi3+cha_vergi4 end) AS [SATI� KDV],
SUM(CASE WHEN cha_evrak_tip=63 then cha_meblag  end) AS [SATI� VERG�LER DAH�L],
SUM(CASE WHEN cha_evrak_tip = 63 then cha_aratoplam end) - MAX(dem_tutar) AS [KAR - VERG�S�Z], 
MAX(DATEDIFF(DAY,dem_fatura_tarihi,getdate())) AS [STOKTA BEKLEME G�N SAYISI],
MAX(DATEDIFF(DAY,[dbo].[fn_OpVadeTarih](cha_vade,dem_fatura_tarihi),getdate())) AS [F�NANSMAN G�N SAYISI]




FROM DEMIRBASLAR 
LEFT OUTER JOIN CARI_HESAP_HAREKETLERI WITH(NOLOCK) ON cha_kasa_hizkod = dem_kod 
WHERE dem_muh_kodu like '254%' 
and dbo.fn_AtikEldekiMiktar(dem_kod,2020) = 0 
--and cha_tarihi BETWEEN '20200101' AND '20200831'
GROUP BY dem_fatura_sira,dem_fatura_tarihi,dem_kod

) ARAC_SATIS
WHERE [SATI� TUTARI] > 0 
AND [SATI� TAR�H�] BETWEEN @ILKTARIH AND @SONTARIH
--ORDER BY [SATI� TAR�H�]

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
COUNT([ALI� TUTARI]),
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
SUM([KAR - VERG�S�Z]) / COUNT([ALI� TUTARI]),
(SUM([KAR - VERG�S�Z] / [G�R�� MAL�YET�])) / COUNT([ALI� TUTARI]) * 100,
SUM([STOKTA BEKLEME G�N SAYISI]) / COUNT([ALI� TUTARI]),
SUM([F�NANSMAN G�N SAYISI]) / COUNT([ALI� TUTARI]),
SUM([KAR - VERG�S�Z]) / COUNT([ALI� TUTARI]),
'ORTALAMA KAR' =  SUM([KAR - VERG�S�Z]) / SUM([G�R�� MAL�YET�]) * 100 ,
'',
'',
'',
'',
'',
SUM([NET KAR]) / COUNT([ALI� TUTARI]) ,
(SUM([NET KAR]) / SUM([G�R�� MAL�YET�])) * 100
FROM 

(

SELECT 
*,
(([ALI� TUTARI KDV DAH�L] * 0.6)/365) *  [STOKTA BEKLEME G�N SAYISI]   AS [FINANSMAN MAL�YET�],
[KAR - VERG�S�Z] - ((([ALI� TUTARI KDV DAH�L] * 0.6)/365) *  [STOKTA BEKLEME G�N SAYISI])  AS [NET KAR]
FROM

(
SELECT
sto_sezon_kodu AS [SIFIR / 2.EL / DEM�RBA�],
dbo.AREM_MusteriAdiBul(sth_stok_kod) as [M��TER�],
dbo.AREM_MusteriVKN(sth_stok_kod) as [VKN_NO],
dbo.AREM_SatisFaturaBelgeNo(sth_stok_kod )as [BELGE NO],
dbo.AREM_TemsilciAdiBul(sth_stok_kod) as [TEM�SLC�], 
sth_stok_kod AS [�ASE],
sto_isim AS [ADI],
MAX(CASE WHEN sth_tip = 0 THEN sth_tarih ELSE '' END) AS [G�R�� TAR�H�],
MAX(CASE WHEN sth_tip = 0 THEN sth_tutar ELSE '' END) AS [ALI� TUTARI],
MAX(CASE WHEN sth_tip = 0 THEN sth_vergi ELSE '' END) AS [ALI� KDV],
MAX(CASE WHEN sth_tip = 0 THEN sth_tutar + sth_vergi ELSE '' END) AS [ALI� TUTARI KDV DAH�L],
SUM(CASE WHEN sth_tip = 1 and sth_cins = 9 THEN sth_tutar else 0 end) as [ALI� �SKONTO],
SUM(CASE WHEN sth_tip = 1 and sth_cins = 9 THEN sth_vergi else 0 end) as [ALI� �SKONTO KDV],
  (select SUM(ISNULL(cha_ft_iskonto1, 0) + 
        ISNULL(cha_ft_iskonto2, 0) + 
        ISNULL(cha_ft_iskonto3, 0) + 
        ISNULL(cha_ft_iskonto4, 0) + 
        ISNULL(cha_ft_iskonto5, 0) + 
        ISNULL(cha_ft_iskonto6, 0)) AS ToplamIskonto
	FROM CARI_HESAP_HAREKETLERI
	WHERE cha_belge_no = dbo.AREM_SatisFaturaBelgeNo(sth_stok_kod)) as [SATI� �SKONTO],
SUM(CASE WHEN sth_tip = 0 and sth_cins = 9 THEN sth_vergi else 0 end) as [SATI� �SKONTO KDV],

MAX(CASE WHEN sth_tip = 0 THEN sth_tutar ELSE '' END) - SUM(CASE WHEN sth_tip = 1 and sth_cins = 9 THEN sth_tutar else 0 end) as [G�R�� MAL�YET�],
MAX(CASE WHEN sth_tip = 1 and sth_cins <> 9 THEN sth_tarih ELSE '' END) AS [SATI� TAR�H�],
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
)AS [SATI� TUTARI],
(
	SELECT SUM(cha_otvtutari)
	FROM CARI_HESAP_HAREKETLERI
	WHERE cha_belge_no = dbo.AREM_SatisFaturaBelgeNo(sth_stok_kod)
)  AS [SATI� �TV],
(
	SELECT SUM(cha_kdv_toplam)
	FROM CARI_HESAP_HAREKETLERI
	WHERE cha_belge_no = dbo.AREM_SatisFaturaBelgeNo(sth_stok_kod)
) AS [SATI� KDV],
(
	SELECT SUM(cha_meblag)
	FROM CARI_HESAP_HAREKETLERI
	WHERE cha_belge_no = dbo.AREM_SatisFaturaBelgeNo(sth_stok_kod)
) AS [SATI� VERG�LER DAH�L],
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
) - (MAX(CASE WHEN sth_tip = 0 THEN sth_tutar ELSE '' END) - SUM(CASE WHEN sth_tip = 1 and sth_cins = 9 THEN sth_tutar else 0 end)) AS [KAR - VERG�S�Z],
DATEDIFF(DAY,MAX(CASE WHEN sth_tip = 0 THEN sth_tarih ELSE '' END),MAX(CASE WHEN sth_tip = 1 THEN sth_tarih ELSE '' END)) AS [STOKTA BEKLEME G�N SAYISI],
DATEDIFF(DAY,MAX(CASE WHEN sth_tip = 0 THEN [dbo].[fn_OpVadeTarih](sth_odeme_op,sth_tarih) ELSE '' END),MAX(CASE WHEN sth_tip = 1 THEN [dbo].[fn_OpVadeTarih](sth_odeme_op,sth_tarih) ELSE '' END)) AS [F�NANSMAN G�N SAYISI]

FROM STOK_HAREKETLERI WITH(NOLOCK)
LEFT JOIN STOKLAR ON sto_kod = sth_stok_kod
WHERE sto_anagrup_kod = 'ARA�'

GROUP BY sth_stok_kod,sto_isim,sto_sezon_kodu

) ARAC_SATIS
WHERE [SATI� TUTARI] > 0 
AND [SATI� TAR�H�] BETWEEN @ILKTARIH AND @SONTARIH
AND [SIFIR / 2.EL / DEM�RBA�] = 'SIFIR'
--ORDER BY [SATI� TAR�H�]
) FORMUL
GROUP BY [SIFIR / 2.EL / DEM�RBA�]

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
COUNT([ALI� TUTARI]),
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
SUM([KAR - VERG�S�Z]) / COUNT([ALI� TUTARI]),
(SUM([KAR - VERG�S�Z]) / SUM([G�R�� MAL�YET�])) / COUNT([ALI� TUTARI]) * 100,
SUM([STOKTA BEKLEME G�N SAYISI]) / COUNT([ALI� TUTARI]),
SUM([F�NANSMAN G�N SAYISI]) / COUNT([ALI� TUTARI]),
SUM([KAR - VERG�S�Z]) / COUNT([ALI� TUTARI]),
'ORTALAMA KAR' =  SUM([KAR - VERG�S�Z]) / SUM([G�R�� MAL�YET�]) * 100 ,
'',
'',
'',
'',
'',
SUM([NET KAR]) / COUNT([ALI� TUTARI]) ,
(SUM([NET KAR]) / SUM([G�R�� MAL�YET�])) * 100
FROM 

(

SELECT 
*,
(([ALI� TUTARI KDV DAH�L] * 0.6)/365) *  [STOKTA BEKLEME G�N SAYISI]   AS [FINANSMAN MAL�YET�],
[KAR - VERG�S�Z] - ((([ALI� TUTARI KDV DAH�L] * 0.6)/365) *  [STOKTA BEKLEME G�N SAYISI])  AS [NET KAR]
FROM

(
SELECT
sto_sezon_kodu AS [SIFIR / 2.EL / DEM�RBA�],
dbo.AREM_MusteriAdiBul(sth_stok_kod) as [M��TER�],
dbo.AREM_MusteriVKN(sth_stok_kod) as [VKN_NO],
dbo.AREM_SatisFaturaBelgeNo(sth_stok_kod )as [BELGE NO],
dbo.AREM_TemsilciAdiBul(sth_stok_kod) as [TEM�SLC�], 
sth_stok_kod AS [�ASE],
sto_isim AS [ADI],
MAX(CASE WHEN sth_tip = 0 THEN sth_tarih ELSE '' END) AS [G�R�� TAR�H�],
MAX(CASE WHEN sth_tip = 0 THEN sth_tutar ELSE '' END) AS [ALI� TUTARI],
MAX(CASE WHEN sth_tip = 0 THEN sth_vergi ELSE '' END) AS [ALI� KDV],
MAX(CASE WHEN sth_tip = 0 THEN sth_tutar + sth_vergi ELSE '' END) AS [ALI� TUTARI KDV DAH�L],
SUM(CASE WHEN sth_tip = 1 and sth_cins = 9 THEN sth_tutar else 0 end) as [ALI� �SKONTO],
SUM(CASE WHEN sth_tip = 1 and sth_cins = 9 THEN sth_vergi else 0 end) as [ALI� �SKONTO KDV],
  (select SUM(ISNULL(cha_ft_iskonto1, 0) + 
        ISNULL(cha_ft_iskonto2, 0) + 
        ISNULL(cha_ft_iskonto3, 0) + 
        ISNULL(cha_ft_iskonto4, 0) + 
        ISNULL(cha_ft_iskonto5, 0) + 
        ISNULL(cha_ft_iskonto6, 0)) AS ToplamIskonto
	FROM CARI_HESAP_HAREKETLERI
	WHERE cha_belge_no = dbo.AREM_SatisFaturaBelgeNo(sth_stok_kod)) as [SATI� �SKONTO],
SUM(CASE WHEN sth_tip = 0 and sth_cins = 9 THEN sth_vergi else 0 end) as [SATI� �SKONTO KDV],

MAX(CASE WHEN sth_tip = 0 THEN sth_tutar ELSE '' END) - SUM(CASE WHEN sth_tip = 1 and sth_cins = 9 THEN sth_tutar else 0 end) as [G�R�� MAL�YET�],
MAX(CASE WHEN sth_tip = 1 and sth_cins <> 9 THEN sth_tarih ELSE '' END) AS [SATI� TAR�H�],
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
) AS [SATI� TUTARI],
(
	SELECT SUM(cha_otvtutari)
	FROM CARI_HESAP_HAREKETLERI
	WHERE cha_belge_no = dbo.AREM_SatisFaturaBelgeNo(sth_stok_kod)
)  AS [SATI� �TV],
(
	SELECT SUM(cha_kdv_toplam)
	FROM CARI_HESAP_HAREKETLERI
	WHERE cha_belge_no = dbo.AREM_SatisFaturaBelgeNo(sth_stok_kod)
) AS [SATI� KDV],
(
	SELECT SUM(cha_meblag)
	FROM CARI_HESAP_HAREKETLERI
	WHERE cha_belge_no = dbo.AREM_SatisFaturaBelgeNo(sth_stok_kod)
) AS [SATI� VERG�LER DAH�L],
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
) - (MAX(CASE WHEN sth_tip = 0 THEN sth_tutar ELSE '' END) - SUM(CASE WHEN sth_tip = 1 and sth_cins = 9 THEN sth_tutar else 0 end)) AS [KAR - VERG�S�Z],
DATEDIFF(DAY,MAX(CASE WHEN sth_tip = 0 THEN sth_tarih ELSE '' END),MAX(CASE WHEN sth_tip = 1 THEN sth_tarih ELSE '' END)) AS [STOKTA BEKLEME G�N SAYISI],
DATEDIFF(DAY,MAX(CASE WHEN sth_tip = 0 THEN [dbo].[fn_OpVadeTarih](sth_odeme_op,sth_tarih) ELSE '' END),MAX(CASE WHEN sth_tip = 1 THEN [dbo].[fn_OpVadeTarih](sth_odeme_op,sth_tarih) ELSE '' END)) AS [F�NANSMAN G�N SAYISI]

FROM STOK_HAREKETLERI WITH(NOLOCK)
LEFT JOIN STOKLAR ON sto_kod = sth_stok_kod
WHERE sto_anagrup_kod = 'ARA�'
GROUP BY sth_stok_kod,sto_isim,sto_sezon_kodu

) ARAC_SATIS
WHERE [SATI� TUTARI] > 0 
AND [SATI� TAR�H�] BETWEEN @ILKTARIH AND @SONTARIH
AND [SIFIR / 2.EL / DEM�RBA�] = '2.EL'
--ORDER BY [SATI� TAR�H�]
) FORMUL
GROUP BY [SIFIR / 2.EL / DEM�RBA�]


-------------------------------------- DEM�RBA� ---------------------------


UNION ALL



SELECT 
'DEM�RBA� ORTALAMA',
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
COUNT([ALI� TUTARI]),
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
SUM([KAR - VERG�S�Z]) / COUNT([ALI� TUTARI]),
(SUM([KAR - VERG�S�Z]) / SUM([G�R�� MAL�YET�])) / COUNT([ALI� TUTARI]) * 100,
SUM([STOKTA BEKLEME G�N SAYISI]) / COUNT([ALI� TUTARI]),
SUM([F�NANSMAN G�N SAYISI]) / COUNT([ALI� TUTARI]),
SUM([KAR - VERG�S�Z]) / COUNT([ALI� TUTARI]) ,
SUM([KAR - VERG�S�Z]) / SUM([G�R�� MAL�YET�]) * 100,
'',
'',
'',
'',
'',
SUM([NET KAR]) / COUNT([ALI� TUTARI]) ,
(SUM([NET KAR]) / SUM([G�R�� MAL�YET�])) * 100
FROM 

(

SELECT 
*,
(([ALI� TUTARI KDV DAH�L] * 0.6)/365) *  [STOKTA BEKLEME G�N SAYISI]   AS [FINANSMAN MAL�YET�],
[KAR - VERG�S�Z] - ((([ALI� TUTARI KDV DAH�L] * 0.6)/365) *  [STOKTA BEKLEME G�N SAYISI])  AS [NET KAR]
FROM

(
SELECT 

'DEM�RBA�' AS [SIFIR / 2.EL / DEM�RBA�],
dbo.AREM_MusteriAdiBul_Demirbas(dem_kod) as [M��TER�],
dbo.AREM_MusteriVKN_Demirbas(dem_kod) as [VKN_NO],
dbo.AREM_SatisBelgeNo_Demirbas(dem_kod )as [BELGE NO],
dbo.AREM_TemsilciAdiBul_Demirbas(dem_kod)  as [TEM�SLC�], 
MAX(dem_kod) AS [�ASE],
MAX(dem_isim) AS [ADI],
--dem_fatura_seri + '-' + convert(nvarchar(50),dem_fatura_sira),
dem_fatura_tarihi AS [G�R�� TAR�H�],
MAX(dem_tutar) AS [ALI� TUTARI], 
MAX(dem_tutar * dbo.fn_VergiYuzde(dem_vergi))/100 AS [ALI� KDV], 
MAX(dem_tutar + ((dem_tutar * dbo.fn_VergiYuzde(dem_vergi)))/100) AS [ALI� TUTARI KDV DAH�L], 
'' as [ALI� �SKONTO],
'' as [ALI� �SKONTO KDV],
'' as [SATI� �SKONTO],
'' as [SATI� �SKONTO KDV],

MAX(dem_tutar)as [G�R�� MAL�YET�], 
MAX(case when cha_evrak_tip = 63 then cha_tarihi end) AS [SATI� TAR�H�],
SUM(CASE WHEN cha_evrak_tip = 63 then cha_aratoplam end) AS [SATI� TUTARI],
'' AS [SATI� �TV],
SUM(CASE WHEN cha_evrak_tip=63 then cha_vergi1+cha_vergi2+cha_vergi3+cha_vergi4 end) AS [SATI� KDV],
SUM(CASE WHEN cha_evrak_tip=63 then cha_meblag  end) AS [SATI� VERG�LER DAH�L],
SUM(CASE WHEN cha_evrak_tip = 63 then cha_aratoplam end) - MAX(dem_tutar) AS [KAR - VERG�S�Z], 
MAX(DATEDIFF(DAY,dem_fatura_tarihi,getdate())) AS [STOKTA BEKLEME G�N SAYISI],
MAX(DATEDIFF(DAY,[dbo].[fn_OpVadeTarih](cha_vade,dem_fatura_tarihi),getdate())) AS [F�NANSMAN G�N SAYISI]


FROM DEMIRBASLAR 
LEFT OUTER JOIN CARI_HESAP_HAREKETLERI WITH(NOLOCK) ON cha_kasa_hizkod = dem_kod 
WHERE dem_muh_kodu like '254%' 
and dbo.fn_AtikEldekiMiktar(dem_kod,2020) = 0 
--and cha_tarihi BETWEEN '20200101' AND '20200831'
GROUP BY dem_fatura_sira,dem_fatura_tarihi,dem_kod

) ARAC_SATIS
WHERE [SATI� TUTARI] > 0 
AND [SATI� TAR�H�] BETWEEN @ILKTARIH AND @SONTARIH
AND [SIFIR / 2.EL / DEM�RBA�] = 'DEM�RBA�'
--ORDER BY [SATI� TAR�H�]
) FORMUL
GROUP BY [SIFIR / 2.EL / DEM�RBA�]

