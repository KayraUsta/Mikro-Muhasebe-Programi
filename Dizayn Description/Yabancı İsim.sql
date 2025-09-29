%%SQL.SELECT S.sto_yabanci_isim
FROM STOKLAR AS S
 WHERE S.sto_kod  = (SELECT S1.sth_stok_kod FROM STOK_HAREKETLERI  AS S1 WHERE S1.sth_Guid =@SGuid)%%