[<
	<@H;@P1 -  @P2 / PERSONEL RAPORU - ZİNCA>
	<@P1;NAME=Mali Yıl,10;TYPE=I>
	<@P2;NAME=Tahakkuk Ay,10;TYPE=I>
>]

DECLARE @YIL AS INT   -- Başlangıç tarihi
DECLARE @AY AS INT   -- Bitiş tarihi
SET     @YIL = @P1
SET     @AY = @P2
SELECT 
    p.per_adi + ' ' + p.per_soyadi        AS AdSoyad,
    p.Per_TcKimlikNo AS TCkimlik,
    c.cari_per_banka_tcmb_kod,
    c.cari_per_banka_tcmb_subekod,
    c.cari_per_banka_hesapno,
    p.per_ucr_hesapno,
    t.pt_net
FROM PERSONELLER p
LEFT JOIN CARI_PERSONEL_TANIMLARI c 
    ON p.Per_TcKimlikNo = c.cari_per_TcKimlikNo  
LEFT JOIN PERSONEL_TAHAKKUKLARI t
    ON p.per_kod = t.pt_pkod
WHERE t.pt_maliyil = @P1
  AND t.pt_tah_ay = @P2;