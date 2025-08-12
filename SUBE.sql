INSERT INTO [dbo].[SUBELER]
           ([Sube_Guid]            -- Şubenin benzersiz kimliği (GUID)
           ,[Sube_DBCno]           -- Veritabanı numarası
           ,[Sube_SpecRECno]       -- Özel kayıt numarası
           ,[Sube_iptal]           -- Şubenin iptal durumu (0: Aktif, 1: İptal)
           ,[Sube_fileid]          -- Dosya kimliği
           ,[Sube_hidden]          -- Şubenin gizli olup olmadığı (0: Görünür, 1: Gizli)
           ,[Sube_kilitli]         -- Şubenin kilitli olup olmadığı (0: Kilitsiz, 1: Kilitli)
           ,[Sube_degisti]         -- Şubede değişiklik yapılıp yapılmadığı (0: Değişmedi, 1: Değişti)
           ,[Sube_checksum]        -- Veri bütünlüğü kontrolü için checksum
           ,[Sube_create_user]     -- Kaydı oluşturan kullanıcı ID'si
           ,[Sube_create_date]     -- Kaydın oluşturulma tarihi
           ,[Sube_lastup_user]     -- Son güncellemeyi yapan kullanıcı ID'si
           ,[Sube_lastup_date]     -- Son güncelleme tarihi
           ,[Sube_bag_firma]       -- Bağlı firma ID'si
           ,[Sube_no]              -- Şube numarası
           ,[Sube_adi]             -- Şubenin adı
           ,[Sube_kodu]            -- Şubenin kodu
           ,[sube_yetkili_email]   -- Şube yetkilisinin e-posta adresi
           ,[sube_Cadde]           -- Şubenin bulunduğu cadde
           ,[sube_Mahalle]         -- Şubenin bulunduğu mahalle
           ,[sube_Sokak]           -- Şubenin bulunduğu sokak
           ,[sube_Semt]            -- Şubenin bulunduğu semt
           ,[sube_Apt_No]          -- Apartman numarası
           ,[sube_Daire_No]        -- Daire numarası
           ,[sube_Posta_Kodu]      -- Posta kodu
           ,[sube_Ilce]            -- Şubenin bulunduğu ilçe
           ,[sube_Il]              -- Şubenin bulunduğu il
           ,[sube_Ulke]            -- Şubenin bulunduğu ülke
           ,[sube_TelNo1]          -- Birinci telefon numarası
           ,[sube_TelNo2]          -- İkinci telefon numarası
           )
     VALUES
           (NEWID()                -- Sube_Guid: benzersiz kimlik
           ,0                      -- Sube_DBCno: veritabanı numarası
           ,0                      -- Sube_SpecRECno: özel kayıt numarası
           ,0                      -- Sube_iptal: iptal durumu (0=aktif)
           ,0                      -- Sube_fileid: dosya kimliği
           ,0                      -- Sube_hidden: gizli mi (0=hayır)
           ,0                      -- Sube_kilitli: kilitli mi (0=hayır)
           ,0                      -- Sube_degisti: değişti mi (0=hayır)
           ,0                      -- Sube_checksum: veri bütünlüğü için
           ,1                      -- Sube_create_user: oluşturan kullanıcı ID
           ,GETDATE()              -- Sube_create_date: oluşturma tarihi
           ,1                      -- Sube_lastup_user: son güncelleyen kullanıcı ID
           ,GETDATE()              -- Sube_lastup_date: son güncelleme tarihi
           ,1                      -- Sube_bag_firma: bağlı firma ID
           ,1                      -- Sube_no: şube numarası
           ,'Merkez Şube'          -- Sube_adi: şube adı
           ,'SUBE001'              -- Sube_kodu: şube kodu
           ,'yetkili@ornekfirma.com' -- sube_yetkili_email: yetkili e-posta
           ,'Atatürk Cad.'         -- sube_Cadde: cadde
           ,'Çankaya Mah.'         -- sube_Mahalle: mahalle
           ,'Gül Sok.'             -- sube_Sokak: sokak
           ,'Çankaya'              -- sube_Semt: semt
           ,'5'                    -- sube_Apt_No: apartman numarası
           ,'10'                   -- sube_Daire_No: daire numarası
           ,'06690'                -- sube_Posta_Kodu: posta kodu
           ,'Çankaya'              -- sube_Ilce: ilçe
           ,'Ankara'               -- sube_Il: il
           ,'Türkiye'              -- sube_Ulke: ülke
           ,'1234567'              -- sube_TelNo1: telefon 1
           ,'7654321'              -- sube_TelNo2: telefon 2
           )