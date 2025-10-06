%%SQL.SELECT 
    CONVERT(
        VARCHAR(15), 
        CAST((
            dbo.fn_CariHesapAnaDovizBakiye(
                '',         -- @FIRMALAR
                0,          -- @CARICINSI
                cha_kod,    -- @CARIKODU
                '',         -- @SORMERKKODU
                '',         -- @PROJEKODU
                NULL,       -- @GRUPNO
                NULL,       -- @ILKTARIH
                NULL,       -- @SONTARIH
                0,          -- @ODEMEEMRIDEGERLEMEDOK
                0,          -- @MusteriTeminatMektubu_Bakiyeyi_Etkilemesin_fl
                0,          -- @FirmaTeminatMektubu_Bakiyeyi_Etkilemesin_fl
                0,          -- @DepozitoCeki_Bakiyeyi_Etkilemesin_fl
                0           -- @DepozitoSenedi_Bakiyeyi_Etkilemesin_fl
            )
        ) AS MONEY), 1
    ) AS AnaDovizBakiye
FROM CARI_HESAP_HAREKETLERI
WHERE cha_Guid = CAST(@CGuid AS uniqueidentifier);%%