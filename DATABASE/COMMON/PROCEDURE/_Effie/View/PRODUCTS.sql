-- View: Products

DROP VIEW IF EXISTS Products;

CREATE OR REPLACE VIEW Products
AS 
  WITH _tmpresult AS (SELECT extId                  
                           , globalCode             
                           , productName            
                           , groupExtId             
                           , groupName              
                           , manufacturerId         
                           , manufacturerName       
                           , brandId                
                           , brandName              
                           , subBrandId             
                           , subBrandName           
                           , categoryExtId          
                           , categoryName           
                           , subCategoryExtId       
                           , subCategoryName        
                           , subCategoryLineExtId   
                           , subCategoryLineName    
                           , unitId                 
                           , additionalUnitId       
                           , typeId                 
                           , unitFactor             
                           , quantity               
                           , length                 
                           , width                  
                           , height                 
                           , vatRate                
                           , basePrice              
                           , needLicense            
                           , ean                    
                           , photoName              
                           , photoChangeDateTime    
                           , isCompetitor           
                           , qntPerPack             
                           , qntPerCase             
                           , qntPerPall             
                           , multiplicity           
                           , sortId                 
                           , fullName               
                           , enableSellByPack       
                           , IsPromoGift            
                           , minOrder               
                           , grossWeight            
                           , isDeleted        
                      FROM dblink ('host=192.168.0.228 dbname=project port=5432 user=project password=sqoII5szOnrcZxJVF1BL'::text
                                 , ('SELECT *
                                    FROM gpSelect_Object_Products_effie(zfCalc_UserAdmin())'
                                    ) :: Text
                                  ) AS gpSelect (extId                  TVarChar   -- Уникальный идентификатор продукта
                                               , globalCode             TVarChar   -- Глобальный код товара
                                               , productName            TVarChar   -- Название продукта
                                               , groupExtId             TVarChar   -- Идентификатор группы товаров
                                               , groupName              TVarChar   -- Название группы товаров     
                                               , manufacturerId         TVarChar   -- Идентификатор производителя 
                                               , manufacturerName       TVarChar   -- Название производителя      
                                               , brandId                TVarChar   -- Идентификатор бренда        
                                               , brandName              TVarChar   -- Название бренда             
                                               , subBrandId             TVarChar   -- Идентификатор бренда        
                                               , subBrandName           TVarChar   -- Название саб-бренда         
                                               , categoryExtId          TVarChar   -- Идентификатор категории     
                                               , categoryName           TVarChar   -- Название категории          
                                               , subCategoryExtId       TVarChar   -- Идентификатор саб-категории 
                                               , subCategoryName        TVarChar   -- Название саб-категории      
                                               , subCategoryLineExtId   TVarChar   -- Идентификатор линейки       
                                               , subCategoryLineName    TVarChar   -- Название линейки            
                                               , unitId                 Integer    --"Id единицы измерения.Пример: 1 - метры, 2 - сантиметры, 3 - киллограммы, 4 - штуки, 5 - литры, 6 - граммы, 7 - денежные единици, 8 - декалитр (10л), 9 - упаковка"
                                               , additionalUnitId       Integer    -- Id единицы измерения.Пример: 4 - штуки при unitId 9 - упаковка"
                                               , typeId                 Integer    -- Id типа продукта. Пример: 1 - SKU, 2 - POSM, 3- ДМП
                                               , unitFactor             TFloat     -- 1 - Весовой/0 - невесовой товар
                                               , quantity               TFloat     -- Кол-во товара в единице измерения (для весового товара unitFactor= 1, количество будет равно 1)
                                               , length                 TFloat     -- Длина                          
                                               , width                  TFloat     -- Ширина                         
                                               , height                 TFloat     -- Высота                         
                                               , vatRate                TFloat     -- Размер НДС. Пример: 0.2        
                                               , basePrice              TFloat     -- Базовая цена                   
                                               , needLicense            Boolean    -- Необходима ли продукту лицензия
                                               , ean                    TVarChar   -- EAN (Штрих код)                
                                               , photoName              TVarChar   -- Название фото                  
                                               , photoChangeDateTime    TVarChar   -- Дата обновления фото           
                                               , isCompetitor           Boolean    -- Признак компании производителя продукта: false - свой/true - чужой (в случае не заполнения поля будет проставлено false)
                                               , qntPerPack             TFloat     -- Кол-во в упаковке
                                               , qntPerCase             TFloat     -- Кол-во в коробке 
                                               , qntPerPall             TFloat     -- Кол-во в паллете 
                                               , multiplicity           TFloat     -- Кратность (кратно какому кол-ву можно набивать этот товар в заказе. Пример: Кратность 3 - можем набить 3 или 6 или 9 и т.д.)
                                               , sortId                 TFloat     -- Порядок сортировки продукта при формировании заказа
                                               , fullName               TVarChar   -- Полное название
                                               , enableSellByPack       Boolean    -- Продажа товаров упаковками false = Нет / true = да     
                                               , IsPromoGift            Boolean    -- Подарочный товар false = Нет / true = да               
                                               , minOrder               TFloat     -- Минимальное кол-во для заказа                          
                                               , grossWeight            TFloat     -- Вес товара, брутто (кг)                                
                                               , isDeleted              Boolean
                                                )
                     )
 --
 SELECT extId                  
      , globalCode             
      , productName            
      , groupExtId             
      , groupName              
      , manufacturerId         
      , manufacturerName       
      , brandId                
      , brandName              
      , subBrandId             
      , subBrandName           
      , categoryExtId          
      , categoryName           
      , subCategoryExtId       
      , subCategoryName        
      , subCategoryLineExtId   
      , subCategoryLineName    
      , unitId                 
      , additionalUnitId       
      , typeId                 
      , unitFactor             
      , quantity               
      , length                 
      , width                  
      , height                 
      , vatRate                
      , basePrice              
      , needLicense            
      , ean                    
      , photoName              
      , photoChangeDateTime    
      , isCompetitor           
      , qntPerPack             
      , qntPerCase             
      , qntPerPall             
      , multiplicity           
      , sortId                 
      , fullName               
      , enableSellByPack       
      , IsPromoGift            
      , minOrder               
      , grossWeight            
      , isDeleted              
   FROM _tmpresult
  ;

ALTER TABLE Products  OWNER TO postgres;

GRANT ALL ON TABLE PUBLIC.Products TO admin;
GRANT ALL ON TABLE PUBLIC.Products TO project;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.03.26                                        *
*/

-- тест
-- SELECT * FROM Products ORDER BY 1
