-- Function: gpInsertUpdate_Object_GoodsBarCode_Load2

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsBarCode_Load_Price (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsBarCode_Load_Price (
    IN inJuridicalId      Integer,   -- Поставщик
    IN inCommonCode       Integer,   --  
    IN inName             TVarChar,  -- Название товара
    IN inProducerName     TVarChar,  -- Производитель
    IN inGoodsCode        TVarChar,  -- Код товара поставщика
    IN inBarCode          TVarChar,  -- Штрих-код
    IN inJuridicalName    TVarChar,   -- Поставщик
    IN inSession          TVarChar   -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbId Integer;
  DECLARE vbItemId Integer;
  DECLARE vbErrorText TVarChar;
  DECLARE vbObjectId Integer;
  DECLARE vbGoodsId Integer;
  DECLARE vbCode Integer;  
  DECLARE vbGoodsMainId Integer;
  DECLARE vbJuridicalId Integer;
  DECLARE vbisLoadBarCode Boolean;
  DECLARE vbGoodsJuridicalId Integer;
  DECLARE vbBarCodeOld TVarChar;
  DECLARE vbGoodsBarCodeId Integer;
  DECLARE vbLinkGoodsId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);
      vbErrorText:= '';

      IF COALESCE (inJuridicalId, 0) = 0
      THEN
          vbErrorText:= vbErrorText || 'Ошибка.Не выбрано юр.лицо';
      END IF;
            
      IF COALESCE (inCommonCode, 0) = 0
      THEN
           vbErrorText:= vbErrorText || 'Нулевой код Моріона;';
      END IF;

      -- определяется <Торговая сеть>
      vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    -- Ищем по общему коду 
    IF COALESCE (inCommonCode, 0) > 0 
    THEN
      SELECT ObjectLink_LinkGoods_GoodsMain.ChildObjectId AS GoodsId
             INTO vbGoodsMainId
      FROM Object AS Object_Goods
           INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                 ON ObjectLink_Goods_Object.ObjectId      = Object_Goods.Id
                                AND ObjectLink_Goods_Object.DescId        = zc_ObjectLink_Goods_Object()
                                AND ObjectLink_Goods_Object.ChildObjectId = zc_Enum_GlobalConst_Marion()
           INNER JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                                 ON ObjectLink_LinkGoods_Goods.ChildObjectId = Object_Goods.Id
                                AND ObjectLink_LinkGoods_Goods.DescId        = zc_ObjectLink_LinkGoods_Goods()
           INNER JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                                 ON ObjectLink_LinkGoods_GoodsMain.ObjectId = ObjectLink_LinkGoods_Goods.ObjectId
                                AND ObjectLink_LinkGoods_GoodsMain.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
      WHERE Object_Goods.ObjectCode = inCommonCode
        AND Object_Goods.DescId = zc_Object_Goods();
    END IF;
   
    -- Ищем по штрих-коду 
    IF COALESCE (vbGoodsMainId, 0) = 0 AND inBarCode <> ''
    THEN
      SELECT ObjectLink_LinkGoods_GoodsMain.ChildObjectId AS GoodsId
             INTO vbGoodsMainId
      FROM Object AS Object_Goods
           INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                 ON ObjectLink_Goods_Object.ObjectId      = Object_Goods.Id
                                AND ObjectLink_Goods_Object.DescId        = zc_ObjectLink_Goods_Object()
                                AND ObjectLink_Goods_Object.ChildObjectId = zc_Enum_GlobalConst_BarCode()
           INNER JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                                 ON ObjectLink_LinkGoods_Goods.ChildObjectId = Object_Goods.Id
                                 AND ObjectLink_LinkGoods_Goods.DescId        = zc_ObjectLink_LinkGoods_Goods()
           INNER JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                                 ON ObjectLink_LinkGoods_GoodsMain.ObjectId = ObjectLink_LinkGoods_Goods.ObjectId
                                AND ObjectLink_LinkGoods_GoodsMain.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
      WHERE Object_Goods.ValueData = inBarCode
        AND Object_Goods.DescId = zc_Object_Goods();
    END IF;

    -- Ищем по коду и inJuridicalId
    IF (COALESCE(vbGoodsMainId, 0) = 0) THEN
      SELECT ObjectLink_LinkGoods_GoodsMain.ChildObjectId AS GoodsId
               INTO vbGoodsMainId
      FROM ObjectString
           INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                 ON ObjectLink_Goods_Object.ObjectId      = ObjectString.ObjectId
                                AND ObjectLink_Goods_Object.DescId        = zc_ObjectLink_Goods_Object()
                                AND ObjectLink_Goods_Object.ChildObjectId = inJuridicalId
           INNER JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                                 ON ObjectLink_LinkGoods_Goods.ChildObjectId = ObjectString.ObjectId
                                AND ObjectLink_LinkGoods_Goods.DescId        = zc_ObjectLink_LinkGoods_Goods()
           INNER JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                                 ON ObjectLink_LinkGoods_GoodsMain.ObjectId = ObjectLink_LinkGoods_Goods.ObjectId
                                AND ObjectLink_LinkGoods_GoodsMain.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
      WHERE ObjectString.ValueData = inGoodsCode
        AND ObjectString.DescId = zc_ObjectString_Goods_Code();
    END IF;
        

      IF COALESCE (vbGoodsMainId, 0) = 0
      THEN
           vbErrorText:= vbErrorText || 'Не найден главный товар;';
      END IF;

      -- загружается ли штрихкод поставщика
      SELECT COALESCE (ObjectBoolean_Juridical_LoadBarCode.ValueData, FALSE) AS isLoadBarCode
      INTO vbisLoadBarCode
      FROM Object AS Object_Juridical
           LEFT JOIN ObjectBoolean AS ObjectBoolean_Juridical_LoadBarCode
                                   ON ObjectBoolean_Juridical_LoadBarCode.ObjectId = Object_Juridical.Id
                                  AND ObjectBoolean_Juridical_LoadBarCode.DescId = zc_ObjectBoolean_Juridical_LoadBarCode()
      WHERE Object_Juridical.DescId = zc_Object_Juridical()
        AND Object_Juridical.Id = inJuridicalId;

      IF COALESCE (vbisLoadBarCode, FALSE) = TRUE
      THEN
           -- ищем ИД товара поставщика
            SELECT ObjectString_Goods_Code.ObjectId
            INTO vbGoodsJuridicalId
            FROM ObjectString AS ObjectString_Goods_Code
                 JOIN ObjectLink AS ObjectLink_Goods_Object
                                 ON ObjectLink_Goods_Object.ObjectId = ObjectString_Goods_Code.ObjectId
                                AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                AND ObjectLink_Goods_Object.ChildObjectId = inJuridicalId 
            WHERE ObjectString_Goods_Code.DescId = zc_ObjectString_Goods_Code()
              AND ObjectString_Goods_Code.ValueData = inGoodsCode;

            IF COALESCE (vbGoodsJuridicalId, 0) = 0
            THEN
                 vbErrorText:= vbErrorText || 'Не найден товар поставщика;';
            END IF; 
         

           IF COALESCE (inBarCode, '') = ''
           THEN 
                vbErrorText:= vbErrorText || 'Не задан штрих-код;';
           ELSE 
                IF COALESCE (vbGoodsMainId, 0) <> 0
                THEN
                     SELECT BarCode INTO vbBarCodeOld FROM gpGet_Object_Goods_BarCode (0, vbGoodsMainId, inSession);
                ELSE
                     vbBarCodeOld:= '';
                END IF; 

                IF (COALESCE (vbBarCodeOld, '') <> '') AND (vbBarCodeOld <> inBarCode)
                THEN
                     vbErrorText:= vbErrorText || 'Попытка смены штрих-кода;';
                ELSE 
                     -- ищем ИД штрих-кода
                     SELECT Object_Goods.Id
                     INTO vbGoodsBarCodeId
                     FROM Object AS Object_Goods
                          JOIN ObjectLink AS ObjectLink_Goods_Object
                                          ON ObjectLink_Goods_Object.ObjectId = Object_Goods.Id
                                         AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                         AND ObjectLink_Goods_Object.ChildObjectId = zc_Enum_GlobalConst_BarCode()
                     WHERE Object_Goods.DescId = zc_Object_Goods()
                       AND Object_Goods.ValueData = inBarCode;

                     IF COALESCE (vbGoodsBarCodeId, 0) = 0
                     THEN
                          vbGoodsBarCodeId:= lpInsertUpdate_Object(0, zc_Object_Goods(), 0, inBarCode);
                          PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Object(), vbGoodsBarCodeId, zc_Enum_GlobalConst_BarCode());
                     END IF;  

                     IF COALESCE (vbGoodsMainId, 0) <> 0
                     THEN
                          SELECT ObjectLink_LinkGoods_Goods.ObjectId
                          INTO vbLinkGoodsId 
                          FROM ObjectLink AS ObjectLink_LinkGoods_Goods
                               JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                                               ON ObjectLink_LinkGoods_GoodsMain.ObjectId = ObjectLink_LinkGoods_Goods.ObjectId
                                              AND ObjectLink_LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                                              AND ObjectLink_LinkGoods_GoodsMain.ChildObjectId = vbGoodsMainId
                          WHERE ObjectLink_LinkGoods_Goods.DescId = zc_ObjectLink_LinkGoods_Goods()
                            AND ObjectLink_LinkGoods_Goods.ChildObjectId = vbGoodsBarCodeId;

                          IF COALESCE (vbLinkGoodsId, 0) = 0
                          THEN
                               vbLinkGoodsId:= gpInsertUpdate_Object_LinkGoods (0, vbGoodsMainId, vbGoodsBarCodeId, inSession);
                          END IF;  

                          IF COALESCE (vbLinkGoodsId, 0) <> 0  
                          THEN -- чистим ненужные связи "товар штрих-код -> главный товар"
                               PERFORM lpDelete_Object(ObjectLink_LinkGoods_Goods.ObjectId, zfCalc_UserAdmin())     
                               FROM ObjectLink AS ObjectLink_Goods_Object
                                    JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                                                    ON ObjectLink_LinkGoods_Goods.ChildObjectId = ObjectLink_Goods_Object.ObjectId
                                                   AND ObjectLink_LinkGoods_Goods.DescId = zc_ObjectLink_LinkGoods_Goods()
                                                   AND ObjectLink_LinkGoods_Goods.ObjectId <> vbLinkGoodsId
                                    JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                                                    ON ObjectLink_LinkGoods_GoodsMain.ObjectId = ObjectLink_LinkGoods_Goods.ObjectId
                                                   AND ObjectLink_LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                                                   AND ObjectLink_LinkGoods_GoodsMain.ChildObjectId = vbGoodsMainId
                               WHERE ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                 AND ObjectLink_Goods_Object.ChildObjectId = zc_Enum_GlobalConst_BarCode();
                          END IF;
                     END IF;
                END IF;
           END IF;

           --vbCode:= (SELECT Object.ObjectCode FROM Object WHERE Object.Id = COALESCE (vbGoodsId, 0) );

           SELECT Id INTO vbId FROM LoadGoodsBarCode WHERE RetailId = vbObjectId AND GoodsJuridicalId = COALESCE (vbGoodsJuridicalId, 0);

           IF COALESCE (vbId, 0) = 0
           THEN
                INSERT INTO LoadGoodsBarCode (RetailId
                                            , GoodsId
                                            , GoodsMainId
                                            , GoodsBarCodeId
                                            , GoodsJuridicalId
                                            , JuridicalId
                                            , Code
                                            , Name
                                            , ProducerName
                                            , GoodsCode
                                            , BarCode
                                            , JuridicalName
                                            , ErrorText
                                             )
                VALUES (vbObjectId
                      , COALESCE (vbGoodsId, 0)::Integer
                      , COALESCE (vbGoodsMainId, 0)::Integer
                      , COALESCE (vbGoodsBarCodeId, 0)::Integer
                      , COALESCE (vbGoodsJuridicalId, 0)::Integer
                      , COALESCE (inJuridicalId, 0)::Integer
                      , vbCode
                      , inName
                      , inProducerName
                      , inGoodsCode
                      , inBarCode
                      , inJuridicalName
                      , vbErrorText
                       )
                RETURNING Id INTO vbId;
           ELSE
                UPDATE LoadGoodsBarCode
                SET GoodsId          = COALESCE (vbGoodsId, 0)::Integer
                  , GoodsMainId      = COALESCE (vbGoodsMainId, 0)::Integer     
                  , GoodsBarCodeId   = COALESCE (vbGoodsBarCodeId, 0)::Integer  
                  , GoodsJuridicalId = COALESCE (vbGoodsJuridicalId, 0)::Integer
                  , JuridicalId      = COALESCE (inJuridicalId, 0)::Integer     
                  , Code             = vbCode                                   
                  , Name             = inName                                   
                  , ProducerName     = inProducerName                           
                  , GoodsCode        = inGoodsCode                              
                  , BarCode          = inBarCode                                
                  , JuridicalName    = inJuridicalName                          
                  , ErrorText        = vbErrorText                              
                WHERE Id = vbId; 
           END IF;

           IF COALESCE (inJuridicalId, 0) <> 0
           THEN
                SELECT Id INTO vbItemId FROM LoadGoodsBarCodeItem WHERE LoadGoodsBarCodeId = vbId AND JuridicalId = inJuridicalId;

                IF COALESCE (vbItemId, 0) = 0
                THEN
                     INSERT INTO LoadGoodsBarCodeItem (LoadGoodsBarCodeId
                                                     , GoodsJuridicalId
                                                     , JuridicalId
                                                     , UserId
                                                     , OperDate
                                                     , GoodsCode
                                                     , BarCode
                                                     , JuridicalName
                                                      )
                     VALUES (vbId
                           , COALESCE (vbGoodsJuridicalId, 0)::Integer
                           , inJuridicalId
                           , vbUserId
                           , CURRENT_TIMESTAMP
                           , inGoodsCode
                           , inBarCode
                           , inJuridicalName 
                            );
                ELSE
                     UPDATE LoadGoodsBarCodeItem
                     SET GoodsJuridicalId   = COALESCE (vbGoodsJuridicalId, 0)::Integer 
                       , UserId             = vbUserId                                 
                       , OperDate           = CURRENT_TIMESTAMP                        
                       , GoodsCode          = inGoodsCode                              
                       , BarCode            = inBarCode                                
                       , JuridicalName      = inJuridicalName                          
                     WHERE Id = vbItemId; 
                END IF;
           END IF;
      END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 07.07.17         *
 05.06.17                                                        *
*/


/*
select * from gpInsertUpdate_Object_GoodsBarCode_Load_Price(inJuridicalId := '59610' 
                                                          , inCommonCode := 316485 
                                                          , inName := 'Eucerin 69653 Шампунь ДермоКапиляр рН5 д/чув.кож.250мл д/ежедн.исп.' 
                                                          , inProducerName := 'KRKA, Словения' 
                                                          , inGoodsCode := '5179104' 
                                                          , inBarCode := '3838989571962' 
                                                          , inJuridicalName:= 'Бадм'  -- Поставщик
                                                          , inSession := '3');
*/