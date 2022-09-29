-- Function: gpInsertUpdate_Object_Boat_From_Excel()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Boat_From_Excel (TDateTime, TDateTime,  TDateTime, TVarChar
                                                             , TVarChar, TVarChar, TVarChar, TVarChar, TFloat ,  TVarChar, TFloat
                                                             , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                             , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                             , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                             , TFloat, TVarChar, TVarChar, TFloat, TVarChar, TVarChar, TFloat
                                                             , TVarChar, TVarChar, TFloat, TVarChar, TVarChar, TFloat, TVarChar
                                                             , TVarChar, TFloat, TVarChar, TVarChar, TFloat, TVarChar, TVarChar
                                                             , TFloat, TFloat, TFloat,  TFloat,  TFloat, TFloat, TFloat
                                                             , TFloat
                                                             , TVarChar
                                                              );

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Boat_From_Excel(

    IN inDateStart           TDateTime ,    -- Начало производства
    IN inDateBegin           TDateTime ,    -- Ввод в эксплуатацию
    IN inDateSale            TDateTime ,    -- Дата Продажи
    IN inArticle             TVarChar  ,    -- Артикул - лодки

    IN inBrandName           TVarChar  ,
    IN inProdModelName       TVarChar  ,
    IN inCIN                 TVarChar  ,    -- № CIN - лодки
    IN inProdEngineName      TVarChar  ,    -- Мотор
    IN inPower               TFloat    ,    -- Мощность
    IN inEngineNum           TVarChar  ,    -- №  - мотора
    IN inHours               TFloat    ,    -- отработанных часов
    IN inHypalon1            TVarChar  ,
    IN inHypalon2            TVarChar  ,
    IN inHypalon3            TVarChar  ,
    IN inHypalon4            TVarChar  ,
    IN inHypalon5            TVarChar  ,
    IN inFiberglassHull      TVarChar  ,
    IN inFiberglassDeck      TVarChar  ,
    IN inFiberglassSteeringConsole TVarChar,
    IN inUpholstery1         TVarChar  ,
    IN inUpholstery2         TVarChar  ,
    IN inUpholstery3         TVarChar  ,
    IN inUpholstery4         TVarChar  ,
    IN inStitchingColor      TVarChar  ,
    IN inStitchingType       TVarChar  ,
    IN inColor1              TVarChar  ,
    IN inColor2              TVarChar  ,
    IN inColor3              TVarChar  ,
    IN inColor4              TVarChar  ,
    IN inColor5              TVarChar  ,

    IN inOptionName1         TVarChar  ,
    IN inOptionPartNumber1   TVarChar  ,
    IN inOptionPrice1        TFloat    ,
    IN inOptionName2         TVarChar  ,
    IN inOptionPartNumber2   TVarChar  ,
    IN inOptionPrice2        TFloat    ,
    IN inOptionName3         TVarChar  ,
    IN inOptionPartNumber3   TVarChar  ,
    IN inOptionPrice3        TFloat    ,
    IN inOptionName4         TVarChar  ,
    IN inOptionPartNumber4   TVarChar  ,
    IN inOptionPrice4        TFloat    ,
    IN inOptionName5         TVarChar  ,
    IN inOptionPartNumber5   TVarChar  ,
    IN inOptionPrice5        TFloat    ,
    IN inOptionName6         TVarChar  ,
    IN inOptionPartNumber6   TVarChar  ,
    IN inOptionPrice6        TFloat    ,
    IN inOptionName7         TVarChar  ,
    IN inOptionPartNumber7   TVarChar  ,
    IN inOptionPrice7        TFloat    ,
    IN inOptionName8         TVarChar  ,
    IN inOptionPartNumber8   TVarChar  ,
    IN inOptionPrice8        TFloat    ,

    IN inLength              TFloat,
    IN inBeam                TFloat,
    IN inHeight              TFloat,
    IN inWeight              TFloat,
    IN inFuel                TFloat,
    IN inSpeed               TFloat,
    IN inSeating             TFloat,

    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbProductId    Integer;
   DECLARE vbBrandId      Integer;
   DECLARE vbProdModelId  Integer;
   DECLARE vbProdEngineId Integer;

   DECLARE vbProdColorGroupId1 Integer;
   DECLARE vbProdColorGroupId2 Integer;
   DECLARE vbProdColorGroupId3 Integer;
   DECLARE vbProdColorGroupId4 Integer;
   DECLARE vbProdColorGroupId5 Integer;
   DECLARE vbProdColorGroupName1 TVarChar;
   DECLARE vbProdColorGroupName2 TVarChar;
   DECLARE vbProdColorGroupName3 TVarChar;
   DECLARE vbProdColorGroupName4 TVarChar;
   DECLARE vbProdColorGroupName5 TVarChar;

   DECLARE vbColorId Integer;
   DECLARE vbProdColorItemsId Integer;
   DECLARE vbProdColorPatternId Integer;
   DECLARE vbProdColorPatternName TVarChar;

   DECLARE vbIsUpdate_ProdColorItems Boolean;

   DECLARE vbProdOptionsId Integer;
   DECLARE vbProdOptItemsId Integer;
   DECLARE vbProdOptPatternId Integer;
   DECLARE vbProdOptPatternName TVarChar;

BEGIN
     -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Product());
     vbUserId:= lpGetUserBySession (inSession);
     
     --
     vbIsUpdate_ProdColorItems:= TRUE;

     -- 1.1. Торговая Марка
     inBrandName:= TRIM (inBrandName);
     -- проверка
     IF COALESCE (TRIM (inBrandName), '') = '' THEN
        --RAISE EXCEPTION 'Ошибка.Должен быть заполнен BrandName.';
        RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Должен быть заполнен BrandName.' :: TVarChar
                                              , inProcedureName := 'gpInsertUpdate_Object_Boat_From_Excel'    :: TVarChar
                                              , inUserId        := vbUserId
                                              );
     END IF;

     -- Поиск
     vbBrandId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inBrandName AND Object.DescId = zc_Object_Brand());
     --
     IF COALESCE (vbBrandId, 0) = 0
     THEN
         -- Создание
         vbBrandId := (SELECT tmp.ioId FROM gpInsertUpdate_Object_Brand (ioId      := 0
                                                                       , ioCode    := 0
                                                                       , inName    := inBrandName
                                                                       , inComment := ''
                                                                       , inSession := inSession
                                                                        ) AS tmp);
     END IF;



     -- 1.2.  Мотор - лодки
     inProdEngineName:= TRIM (inProdEngineName);
     -- проверка
     IF COALESCE (TRIM (inProdEngineName), '') = '' THEN
        --RAISE EXCEPTION 'Ошибка.Должен быть заполнен Engine.';
        RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Должен быть заполнен Engine.' :: TVarChar
                                              , inProcedureName := 'gpInsertUpdate_Object_Boat_From_Excel'    :: TVarChar
                                              , inUserId        := vbUserId
                                              );
     END IF;

     -- Поиск
     vbProdEngineId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inProdEngineName AND Object.DescId = zc_Object_ProdEngine());
     --
     IF COALESCE (vbProdEngineId, 0) = 0
     THEN
         -- Создание
         vbProdEngineId := (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdEngine (ioId      := 0
                                                                                 , inCode    := 0
                                                                                 , inName    := inProdEngineName
                                                                                 , inPower   := inPower
                                                                                 , inComment := ''
                                                                                 , inSession := inSession
                                                                                  ) AS tmp);
     END IF;



     -- 1.3. Модель - лодки
     inProdModelName:= TRIM (inProdModelName);
     -- проверка
     IF COALESCE (TRIM (inProdModelName), '') = '' THEN
        --RAISE EXCEPTION 'Ошибка.Должен быть заполнен Model.';
        RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Должен быть заполнен Model.' :: TVarChar
                                              , inProcedureName := 'gpInsertUpdate_Object_Boat_From_Excel'    :: TVarChar
                                              , inUserId        := vbUserId
                                              );
     END IF;

     -- Поиск
     vbProdModelId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inProdModelName AND Object.DescId = zc_Object_ProdModel());
     --
     IF COALESCE (vbProdModelId, 0) = 0
     THEN
         -- Создание
         vbProdModelId := (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdModel (ioId           := 0
                                                                               , inCode         := 0
                                                                               , inName         := inProdModelName
                                                                               , inLength       := inLength
                                                                               , inBeam         := inBeam
                                                                               , inHeight       := inHeight
                                                                               , inWeight       := inWeight
                                                                               , inFuel         := inFuel
                                                                               , inSpeed        := inSpeed
                                                                               , inSeating      := inSeating
                                                                               , inComment      := ''
                                                                               , inBrandId      := vbBrandId
                                                                               , inProdEngineId := vbProdEngineId
                                                                               , inSession      := inSession
                                                                                ) AS tmp);
     END IF;


     -- 2. Артикул - лодки
     inArticle:= TRIM (inArticle);
     -- проверка
     IF COALESCE (TRIM (inArticle), '') = '' THEN
        --RAISE EXCEPTION 'Ошибка.Должен быть заполнен Артикул - лодки.';
        RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Должен быть заполнен Артикул - лодки.' :: TVarChar
                                              , inProcedureName := 'gpInsertUpdate_Object_Boat_From_Excel'    :: TVarChar
                                              , inUserId        := vbUserId
                                              );
     END IF;
     -- проверка
     IF COALESCE (TRIM (inCIN), '') = '' THEN
        --RAISE EXCEPTION 'Ошибка.Должен быть заполнен CIN.';
        RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Должен быть заполнен CIN.' :: TVarChar
                                              , inProcedureName := 'gpInsertUpdate_Object_Boat_From_Excel'    :: TVarChar
                                              , inUserId        := vbUserId
                                              );
     END IF;
     -- проверка
     IF COALESCE (TRIM (inEngineNum), '') = '' THEN
        --RAISE EXCEPTION 'Ошибка.Должен быть заполнен EngineNum.';
        RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Должен быть заполнен EngineNum.' :: TVarChar
                                              , inProcedureName := 'gpInsertUpdate_Object_Boat_From_Excel'    :: TVarChar
                                              , inUserId        := vbUserId
                                              );
     END IF;

     -- Поиск
     vbProductId:= (SELECT Object.Id FROM ObjectString AS OS_Article JOIN Object ON Object.Id = OS_Article.ObjectId AND Object.DescId = zc_Object_Product() AND Object.isErased = FALSE WHERE OS_Article.DescId = zc_ObjectString_Article() AND OS_Article.ValueData ILIKE inArticle);
     --
     IF COALESCE (vbProductId, 0) = 0 OR 1=1
     THEN
         -- Создание
         vbProductId := (SELECT tmp.ioId FROM gpInsertUpdate_Object_Boat_From_Excel (ioId            := vbProductId
                                                                           , inCode          := CASE WHEN vbProductId > 0 THEN (SELECT Object.ObjectCode FROM Object WHERE Object.Id = vbProductId) ELSE NEXTVAL ('Object_Product_seq') END :: Integer
                                                                           , inName          := SUBSTRING (inBrandName, 1, 2) || ' ' || inProdModelName || ' ' || inProdEngineName || ' ' || inCIN
                                                                           , inBrandId       := vbBrandId
                                                                           , inModelId       := vbProdModelId
                                                                           , inEngineId      := vbProdEngineId
                                                                           , inHours         := inHours
                                                                           , inDateStart     := inDateStart
                                                                           , inDateBegin     := inDateBegin
                                                                           , inDateSale      := CASE WHEN EXISTS (SELECT 1 FROM ObjectDate WHERE ObjectDate.ObjectId = vbProductId AND ObjectDate.DescId = zc_ObjectDate_Product_DateSale() AND ObjectDate.ValueData = zc_DateStart()) OR COALESCE (vbProductId, 0) = 0 THEN inDateSale ELSE NULL END
                                                                           , inArticle       := inArticle
                                                                           , inCIN           := inCIN
                                                                           , inEngineNum     := inEngineNum
                                                                           , inComment       := ''
                                                                           , inSession       := inSession
                                                                            ) AS tmp);
     END IF;


     -- 3.1. Hypalon
     vbProdColorGroupName1:= 'Hypalon';
     -- Поиск
     vbProdColorGroupId1:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE vbProdColorGroupName1 AND Object.DescId = zc_Object_ProdColorGroup());
     IF COALESCE (vbProdColorGroupId1, 0) = 0
     THEN
         -- Создание
         vbProdColorGroupId1:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorGroup (ioId      := 0
                                                                                         , ioCode    := 0
                                                                                         , inName    := vbProdColorGroupName1
                                                                                         , inComment := ''
                                                                                         , inSession := inSession
                                                                                          ) AS tmp);
     END IF;

     -- 3.2. корпус + палуба + Консоль рулевого управления
     vbProdColorGroupName2:= 'Fiberglass';
     -- Поиск
     vbProdColorGroupId2:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE vbProdColorGroupName2 AND Object.DescId = zc_Object_ProdColorGroup());
     IF COALESCE (vbProdColorGroupId2, 0) = 0
     THEN
         -- Создание
         vbProdColorGroupId2:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorGroup (ioId      := 0
                                                                                         , ioCode    := 0
                                                                                         , inName    := vbProdColorGroupName2
                                                                                         , inComment := ''
                                                                                         , inSession := inSession
                                                                                          ) AS tmp);
     END IF;

     -- 3.3. Обивка
     vbProdColorGroupName3:= 'Upholstery';
     -- Поиск
     vbProdColorGroupId3:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE vbProdColorGroupName3 AND Object.DescId = zc_Object_ProdColorGroup());
     IF COALESCE (vbProdColorGroupId3, 0) = 0
     THEN
         -- Создание
         vbProdColorGroupId3:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorGroup (ioId      := 0
                                                                                         , ioCode    := 0
                                                                                         , inName    := vbProdColorGroupName3
                                                                                         , inComment := ''
                                                                                         , inSession := inSession
                                                                                          ) AS tmp);
     END IF;

     -- 3.4. Цвет строчки + Тип строчки
     vbProdColorGroupName4:= 'Stitching';
     -- Поиск
     vbProdColorGroupId4:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE vbProdColorGroupName4 AND Object.DescId = zc_Object_ProdColorGroup());
     IF COALESCE (vbProdColorGroupId4, 0) = 0
     THEN
         -- Создание
         vbProdColorGroupId4:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorGroup (ioId      := 0
                                                                                         , ioCode    := 0
                                                                                         , inName    := vbProdColorGroupName4
                                                                                         , inComment := ''
                                                                                         , inSession := inSession
                                                                                          ) AS tmp);
     END IF;

     -- 3.5. Цвет
     vbProdColorGroupName5:= 'Color';
     -- Поиск
     vbProdColorGroupId5:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE vbProdColorGroupName5 AND Object.DescId = zc_Object_ProdColorGroup());
     IF COALESCE (vbProdColorGroupId5, 0) = 0
     THEN
         -- Создание
         vbProdColorGroupId5:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorGroup (ioId      := 0
                                                                                         , ioCode    := 0
                                                                                         , inName    := vbProdColorGroupName5
                                                                                         , inComment := ''
                                                                                         , inSession := inSession
                                                                                          ) AS tmp);
     END IF;


     -- 4.1.  ProdColorItemsId - Hypalon
     inHypalon1:= TRIM (inHypalon1);
     IF inHypalon1 <> ''
     THEN
         vbProdColorPatternId:= 0;
         vbProdColorPatternName:= '№1';
         -- Поиск - ProdColorPattern
         vbProdColorPatternId:= (SELECT Object.Id
                                 FROM ObjectLink AS OL_ProdColorGroup
                                      JOIN Object ON Object.Id = OL_ProdColorGroup.ObjectId
                                                 AND Object.ValueData ILIKE vbProdColorPatternName
                                 WHERE OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId1
                                   AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
                                );
         IF COALESCE (vbProdColorPatternId, 0) = 0
         THEN
             -- Создание
             vbProdColorPatternId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorPattern (ioId              := 0
                                                                                                , inCode            := 0
                                                                                                , inName            := vbProdColorPatternName
                                                                                                , inProdColorGroupId:= vbProdColorGroupId1
                                                                                                , inGoodsId         := 0
                                                                                                , ioComment         := ''
                                                                                                , ioProdColorName   := ''
                                                                                                , inSession         := inSession
                                                                                                 ) AS tmp);
         END IF;

         vbColorId:= 0;
         -- Поиск - Color
         vbColorId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inHypalon1 AND Object.DescId = zc_Object_ProdColor());
         IF COALESCE (vbColorId, 0) = 0
         THEN
             -- Создание
             vbColorId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColor_Load (ioId      := 0
                                                                                   , ioCode    := 0
                                                                                   , inName    := inHypalon1
                                                                                   , inComment := ''
                                                                                   , inSession := inSession
                                                                                    ) AS tmp);
         END IF;

         -- Поиск - Items
         vbProdColorItemsId:= (SELECT OL_Product.ObjectId
                               FROM ObjectLink AS OL_Product
                                    INNER JOIN ObjectLink AS OL_ProdColorGroup
                                                          ON OL_ProdColorGroup.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorItems_ProdColorGroup()
                                                         AND OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId1
                                    INNER JOIN Object AS Object_ProdColorItems
                                                      ON Object_ProdColorItems.Id         = OL_Product.ObjectId
                                                     AND Object_ProdColorItems.isErased   = FALSE
                                    INNER JOIN ObjectLink AS OL_ProdColorPattern
                                                          ON OL_ProdColorPattern.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorPattern.DescId        = zc_ObjectLink_ProdColorItems_ProdColorPattern()
                                                         AND OL_ProdColorPattern.ChildObjectId = vbProdColorPatternId
                               WHERE OL_Product.ChildObjectId = vbProductId
                                 AND OL_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                              );

         IF COALESCE (vbProdColorItemsId, 0) = 0 OR vbIsUpdate_ProdColorItems = TRUE
         THEN
             -- Создание
             vbProdColorItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorItems (ioId                := 0
                                                                                            , inCode              := 1
                                                                                            , inProductId         := vbProductId
                                                                                            , inGoodsId           := 0
                                                                                            , inProdColorPatternId:= vbProdColorPatternId
                                                                                            , inComment           := ''
                                                                                            , inSession           := inSession
                                                                                             ) AS tmp);
         END IF;

     END IF;


     -- 4.2.  ProdColorItemsId - Hypalon
     inHypalon2:= TRIM (inHypalon2);
     IF inHypalon2 <> ''
     THEN
         vbProdColorPatternId:= 0;
         vbProdColorPatternName:= '№2';
         -- Поиск - ProdColorPattern
         vbProdColorPatternId:= (SELECT Object.Id
                                 FROM ObjectLink AS OL_ProdColorGroup
                                      JOIN Object ON Object.Id = OL_ProdColorGroup.ObjectId
                                                 AND Object.ValueData ILIKE vbProdColorPatternName
                                 WHERE OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId1
                                   AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
                                );
         IF COALESCE (vbProdColorPatternId, 0) = 0
         THEN
             -- Создание
             vbProdColorPatternId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorPattern (ioId              := 0
                                                                                                , inCode            := 0
                                                                                                , inName            := vbProdColorPatternName
                                                                                                , inProdColorGroupId:= vbProdColorGroupId1
                                                                                                , inGoodsId         := 0
                                                                                                , ioComment         := ''
                                                                                                , ioProdColorName   := ''
                                                                                                , inSession         := inSession
                                                                                                 ) AS tmp);
         END IF;

         vbColorId:= 0;
         -- Поиск - Color
         vbColorId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inHypalon2 AND Object.DescId = zc_Object_ProdColor());
         IF COALESCE (vbColorId, 0) = 0
         THEN
             -- Создание
             vbColorId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColor (ioId      := 0
                                                                              , ioCode    := 0
                                                                              , inName    := inHypalon2
                                                                              , inComment := ''
                                                                              , inSession := inSession
                                                                               ) AS tmp);
         END IF;

         -- Поиск - Items
         vbProdColorItemsId:= (SELECT OL_Product.ObjectId
                               FROM ObjectLink AS OL_Product
                                    INNER JOIN ObjectLink AS OL_ProdColorGroup
                                                          ON OL_ProdColorGroup.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorItems_ProdColorGroup()
                                                         AND OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId1
                                    INNER JOIN Object AS Object_ProdColorItems
                                                      ON Object_ProdColorItems.Id         = OL_Product.ObjectId
                                                     AND Object_ProdColorItems.isErased   = FALSE
                                    INNER JOIN ObjectLink AS OL_ProdColorPattern
                                                          ON OL_ProdColorPattern.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorPattern.DescId        = zc_ObjectLink_ProdColorItems_ProdColorPattern()
                                                         AND OL_ProdColorPattern.ChildObjectId = vbProdColorPatternId
                               WHERE OL_Product.ChildObjectId = vbProductId
                                 AND OL_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                              );

         IF COALESCE (vbProdColorItemsId, 0) = 0 OR vbIsUpdate_ProdColorItems = TRUE
         THEN
             -- Создание
             vbProdColorItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorItems (ioId                := vbProdColorItemsId
                                                                                            , inCode              := 2
                                                                                            , inProductId         := vbProductId
                                                                                            , inGoodsId           := 0
                                                                                            --, inProdColorId       := vbColorId
                                                                                            , inProdColorPatternId:= vbProdColorPatternId
                                                                                            , inComment           := ''
                                                                                            , inSession           := inSession
                                                                                             ) AS tmp);
         END IF;

     END IF;


     -- 5.1.  ProdColorItemsId - Fiberglass - Deck - SteeringConsole
     inFiberglassHull:= TRIM (inFiberglassHull);
     IF inFiberglassHull <> ''
     THEN
         vbProdColorPatternId:= 0;
         vbProdColorPatternName:= 'Hull';
         -- Поиск - ProdColorPattern
         vbProdColorPatternId:= (SELECT Object.Id
                                 FROM ObjectLink AS OL_ProdColorGroup
                                      JOIN Object ON Object.Id = OL_ProdColorGroup.ObjectId
                                                 AND Object.ValueData ILIKE vbProdColorPatternName
                                 WHERE OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId2
                                   AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
                                );
         IF COALESCE (vbProdColorPatternId, 0) = 0
         THEN
             -- Создание
             vbProdColorPatternId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorPattern (ioId              := 0
                                                                                                , inCode            := 0
                                                                                                , inName            := vbProdColorPatternName
                                                                                                , inProdColorGroupId:= vbProdColorGroupId2
                                                                                                , inGoodsId         := 0
                                                                                                , ioComment         := ''
                                                                                                , ioProdColorName   := ''
                                                                                                , inSession         := inSession
                                                                                                 ) AS tmp);
         END IF;

         vbColorId:= 0;
         -- Поиск - Color
         vbColorId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inFiberglassHull AND Object.DescId = zc_Object_ProdColor());
         IF COALESCE (vbColorId, 0) = 0
         THEN
             -- Создание
             vbColorId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColor (ioId      := 0
                                                                              , ioCode    := 0
                                                                              , inName    := inFiberglassHull
                                                                              , inComment := ''
                                                                              , inSession := inSession
                                                                               ) AS tmp);
         END IF;

         -- Поиск - Items
         vbProdColorItemsId:= (SELECT OL_Product.ObjectId
                               FROM ObjectLink AS OL_Product
                                    INNER JOIN ObjectLink AS OL_ProdColorGroup
                                                          ON OL_ProdColorGroup.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorItems_ProdColorGroup()
                                                         AND OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId2
                                    INNER JOIN Object AS Object_ProdColorItems
                                                      ON Object_ProdColorItems.Id         = OL_Product.ObjectId
                                                     AND Object_ProdColorItems.isErased   = FALSE
                                    INNER JOIN ObjectLink AS OL_ProdColorPattern
                                                          ON OL_ProdColorPattern.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorPattern.DescId        = zc_ObjectLink_ProdColorItems_ProdColorPattern()
                                                         AND OL_ProdColorPattern.ChildObjectId = vbProdColorPatternId
                               WHERE OL_Product.ChildObjectId = vbProductId
                                 AND OL_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                              );

         IF COALESCE (vbProdColorItemsId, 0) = 0 OR vbIsUpdate_ProdColorItems = TRUE
         THEN
             -- Создание
             vbProdColorItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorItems (ioId                := vbProdColorItemsId
                                                                                            , inCode              := 1
                                                                                            , inProductId         := vbProductId
                                                                                            , inGoodsId           := 0
                                                                                            --, inProdColorGroupId  := vbProdColorGroupId2
                                                                                            --, inProdColorId       := vbColorId
                                                                                            , inProdColorPatternId:= vbProdColorPatternId
                                                                                            , inComment           := ''
                                                                                            , inSession           := inSession
                                                                                             ) AS tmp);
         END IF;

     END IF;

     -- 5.2.  ProdColorItemsId - Fiberglass - Deck - SteeringConsole
     inFiberglassDeck:= TRIM (inFiberglassDeck);
     IF inFiberglassDeck <> ''
     THEN
         vbProdColorPatternId:= 0;
         vbProdColorPatternName:= 'Deck';
         -- Поиск - ProdColorPattern
         vbProdColorPatternId:= (SELECT Object.Id
                                 FROM ObjectLink AS OL_ProdColorGroup
                                      JOIN Object ON Object.Id = OL_ProdColorGroup.ObjectId
                                                 AND Object.ValueData ILIKE vbProdColorPatternName
                                 WHERE OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId2
                                   AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
                                );
         IF COALESCE (vbProdColorPatternId, 0) = 0
         THEN
             -- Создание
             vbProdColorPatternId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorPattern (ioId              := 0
                                                                                                , inCode            := 0
                                                                                                , inName            := vbProdColorPatternName
                                                                                                , inProdColorGroupId:= vbProdColorGroupId2
                                                                                                , inGoodsId         := 0
                                                                                                , ioComment         := ''
                                                                                                , ioProdColorName   := ''
                                                                                                , inSession         := inSession
                                                                                                 ) AS tmp);
         END IF;

         vbColorId:= 0;
         -- Поиск - Color
         vbColorId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inFiberglassDeck AND Object.DescId = zc_Object_ProdColor());
         IF COALESCE (vbColorId, 0) = 0
         THEN
             -- Создание
             vbColorId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColor (ioId      := 0
                                                                              , ioCode    := 0
                                                                              , inName    := inFiberglassDeck
                                                                              , inComment := ''
                                                                              , inSession := inSession
                                                                               ) AS tmp);
         END IF;

         -- Поиск - Items
         vbProdColorItemsId:= (SELECT OL_Product.ObjectId
                               FROM ObjectLink AS OL_Product
                                    INNER JOIN ObjectLink AS OL_ProdColorGroup
                                                          ON OL_ProdColorGroup.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorItems_ProdColorGroup()
                                                         AND OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId2
                                    INNER JOIN Object AS Object_ProdColorItems
                                                      ON Object_ProdColorItems.Id         = OL_Product.ObjectId
                                                     AND Object_ProdColorItems.isErased   = FALSE
                                    INNER JOIN ObjectLink AS OL_ProdColorPattern
                                                          ON OL_ProdColorPattern.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorPattern.DescId        = zc_ObjectLink_ProdColorItems_ProdColorPattern()
                                                         AND OL_ProdColorPattern.ChildObjectId = vbProdColorPatternId
                               WHERE OL_Product.ChildObjectId = vbProductId
                                 AND OL_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                              );

         IF COALESCE (vbProdColorItemsId, 0) = 0 OR vbIsUpdate_ProdColorItems = TRUE
         THEN
             -- Создание
             vbProdColorItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorItems (ioId                := vbProdColorItemsId
                                                                                            , inCode              := 2
                                                                                            , inProductId         := vbProductId
                                                                                            , inGoodsId           := 0
                                                                                            --, inProdColorGroupId  := vbProdColorGroupId2
                                                                                            --, inProdColorId       := vbColorId
                                                                                            , inProdColorPatternId:= vbProdColorPatternId
                                                                                            , inComment           := ''
                                                                                            , inSession           := inSession
                                                                                             ) AS tmp);
         END IF;

     END IF;


     -- 5.3.  ProdColorItemsId - Fiberglass - Deck - SteeringConsole
     inFiberglassSteeringConsole:= TRIM (inFiberglassSteeringConsole);
     IF inFiberglassSteeringConsole <> ''
     THEN
         vbProdColorPatternId:= 0;
         vbProdColorPatternName:= 'SteeringConsole';
         -- Поиск - ProdColorPattern
         vbProdColorPatternId:= (SELECT Object.Id
                                 FROM ObjectLink AS OL_ProdColorGroup
                                      JOIN Object ON Object.Id = OL_ProdColorGroup.ObjectId
                                                 AND Object.ValueData ILIKE vbProdColorPatternName
                                 WHERE OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId2
                                   AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
                                );
         IF COALESCE (vbProdColorPatternId, 0) = 0
         THEN
             -- Создание
             vbProdColorPatternId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorPattern (ioId              := 0
                                                                                                , inCode            := 0
                                                                                                , inName            := vbProdColorPatternName
                                                                                                , inProdColorGroupId:= vbProdColorGroupId2
                                                                                                , inGoodsId         := 0
                                                                                                , ioComment         := ''
                                                                                                , ioProdColorName   := ''
                                                                                                , inSession         := inSession
                                                                                                 ) AS tmp);
         END IF;

         vbColorId:= 0;
         -- Поиск - Color
         vbColorId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inFiberglassSteeringConsole AND Object.DescId = zc_Object_ProdColor());
         IF COALESCE (vbColorId, 0) = 0
         THEN
             -- Создание
             vbColorId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColor (ioId      := 0
                                                                              , ioCode    := 0
                                                                              , inName    := inFiberglassSteeringConsole
                                                                              , inComment := ''
                                                                              , inSession := inSession
                                                                               ) AS tmp);
         END IF;

         -- Поиск - Items
         vbProdColorItemsId:= (SELECT OL_Product.ObjectId
                               FROM ObjectLink AS OL_Product
                                    INNER JOIN ObjectLink AS OL_ProdColorGroup
                                                          ON OL_ProdColorGroup.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorItems_ProdColorGroup()
                                                         AND OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId2
                                    INNER JOIN Object AS Object_ProdColorItems
                                                      ON Object_ProdColorItems.Id         = OL_Product.ObjectId
                                                     AND Object_ProdColorItems.isErased   = FALSE
                                    INNER JOIN ObjectLink AS OL_ProdColorPattern
                                                          ON OL_ProdColorPattern.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorPattern.DescId        = zc_ObjectLink_ProdColorItems_ProdColorPattern()
                                                         AND OL_ProdColorPattern.ChildObjectId = vbProdColorPatternId
                               WHERE OL_Product.ChildObjectId = vbProductId
                                 AND OL_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                              );

         IF COALESCE (vbProdColorItemsId, 0) = 0 OR vbIsUpdate_ProdColorItems = TRUE
         THEN
             -- Создание
             vbProdColorItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorItems (ioId                := vbProdColorItemsId
                                                                                            , inCode              := 3
                                                                                            , inProductId         := vbProductId
                                                                                            , inGoodsId           := 0
                                                                                            --, inProdColorGroupId  := vbProdColorGroupId2
                                                                                            --, inProdColorId       := vbColorId
                                                                                            , inProdColorPatternId:= vbProdColorPatternId
                                                                                            , inComment           := ''
                                                                                            , inSession           := inSession
                                                                                             ) AS tmp);
         END IF;

     END IF;


     -- 6.1.  ProdColorItemsId - Upholstery
     inUpholstery1:= TRIM (inUpholstery1);
     IF inUpholstery1 <> ''
     THEN
         vbProdColorPatternId:= 0;
         vbProdColorPatternName:= '1';
         -- Поиск - ProdColorPattern
         vbProdColorPatternId:= (SELECT Object.Id
                                 FROM ObjectLink AS OL_ProdColorGroup
                                      JOIN Object ON Object.Id = OL_ProdColorGroup.ObjectId
                                                 AND Object.ValueData ILIKE vbProdColorPatternName
                                 WHERE OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId3
                                   AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
                                );
         IF COALESCE (vbProdColorPatternId, 0) = 0
         THEN
             -- Создание
             vbProdColorPatternId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorPattern (ioId              := 0
                                                                                                , inCode            := 0
                                                                                                , inName            := vbProdColorPatternName
                                                                                                , inProdColorGroupId:= vbProdColorGroupId3
                                                                                                , inGoodsId         := 0
                                                                                                , ioComment         := ''
                                                                                                , ioProdColorName   := ''
                                                                                                , inSession         := inSession
                                                                                                 ) AS tmp);
         END IF;

         vbColorId:= 0;
         -- Поиск - Color
         vbColorId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inUpholstery1 AND Object.DescId = zc_Object_ProdColor());
         IF COALESCE (vbColorId, 0) = 0
         THEN
             -- Создание
             vbColorId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColor (ioId      := 0
                                                                              , ioCode    := 0
                                                                              , inName    := inUpholstery1
                                                                              , inComment := ''
                                                                              , inSession := inSession
                                                                               ) AS tmp);
         END IF;

         -- Поиск - Items
         vbProdColorItemsId:= (SELECT OL_Product.ObjectId
                               FROM ObjectLink AS OL_Product
                                    INNER JOIN ObjectLink AS OL_ProdColorGroup
                                                          ON OL_ProdColorGroup.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorItems_ProdColorGroup()
                                                         AND OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId3
                                    INNER JOIN Object AS Object_ProdColorItems
                                                      ON Object_ProdColorItems.Id         = OL_Product.ObjectId
                                                     AND Object_ProdColorItems.isErased   = FALSE
                                    INNER JOIN ObjectLink AS OL_ProdColorPattern
                                                          ON OL_ProdColorPattern.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorPattern.DescId        = zc_ObjectLink_ProdColorItems_ProdColorPattern()
                                                         AND OL_ProdColorPattern.ChildObjectId = vbProdColorPatternId
                               WHERE OL_Product.ChildObjectId = vbProductId
                                 AND OL_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                              );

         IF COALESCE (vbProdColorItemsId, 0) = 0 OR vbIsUpdate_ProdColorItems = TRUE
         THEN
             -- Создание
             vbProdColorItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorItems (ioId                := vbProdColorItemsId
                                                                                            , inCode              := 1
                                                                                            , inProductId         := vbProductId
                                                                                            , inGoodsId           := 0
                                                                                            --, inProdColorGroupId  := vbProdColorGroupId3
                                                                                            --, inProdColorId       := vbColorId
                                                                                            , inProdColorPatternId:= vbProdColorPatternId
                                                                                            , inComment           := ''
                                                                                            , inSession           := inSession
                                                                                             ) AS tmp);
         END IF;

     END IF;


     -- 6.2.  ProdColorItemsId - Upholstery
     inUpholstery2:= TRIM (inUpholstery2);
     IF inUpholstery2 <> ''
     THEN
         vbProdColorPatternId:= 0;
         vbProdColorPatternName:= '2';
         -- Поиск - ProdColorPattern
         vbProdColorPatternId:= (SELECT Object.Id
                                 FROM ObjectLink AS OL_ProdColorGroup
                                      JOIN Object ON Object.Id = OL_ProdColorGroup.ObjectId
                                                 AND Object.ValueData ILIKE vbProdColorPatternName
                                 WHERE OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId3
                                   AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
                                );
         IF COALESCE (vbProdColorPatternId, 0) = 0
         THEN
             -- Создание
             vbProdColorPatternId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorPattern (ioId              := 0
                                                                                                , inCode            := 0
                                                                                                , inName            := vbProdColorPatternName
                                                                                                , inProdColorGroupId:= vbProdColorGroupId3
                                                                                                , inGoodsId         := 0
                                                                                                , ioComment         := ''
                                                                                                , ioProdColorName   := ''
                                                                                                , inSession         := inSession
                                                                                                 ) AS tmp);
         END IF;

         vbColorId:= 0;
         -- Поиск - Color
         vbColorId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inUpholstery2 AND Object.DescId = zc_Object_ProdColor());
         IF COALESCE (vbColorId, 0) = 0
         THEN
             -- Создание
             vbColorId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColor (ioId      := 0
                                                                              , ioCode    := 0
                                                                              , inName    := inUpholstery2
                                                                              , inComment := ''
                                                                              , inSession := inSession
                                                                               ) AS tmp);
         END IF;

         -- Поиск - Items
         vbProdColorItemsId:= (SELECT OL_Product.ObjectId
                               FROM ObjectLink AS OL_Product
                                    INNER JOIN ObjectLink AS OL_ProdColorGroup
                                                          ON OL_ProdColorGroup.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorItems_ProdColorGroup()
                                                         AND OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId3
                                    INNER JOIN Object AS Object_ProdColorItems
                                                      ON Object_ProdColorItems.Id         = OL_Product.ObjectId
                                                     AND Object_ProdColorItems.isErased   = FALSE
                                    INNER JOIN ObjectLink AS OL_ProdColorPattern
                                                          ON OL_ProdColorPattern.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorPattern.DescId        = zc_ObjectLink_ProdColorItems_ProdColorPattern()
                                                         AND OL_ProdColorPattern.ChildObjectId = vbProdColorPatternId
                               WHERE OL_Product.ChildObjectId = vbProductId
                                 AND OL_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                              );

         IF COALESCE (vbProdColorItemsId, 0) = 0 OR vbIsUpdate_ProdColorItems = TRUE
         THEN
             -- Создание
             vbProdColorItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorItems (ioId                := vbProdColorItemsId
                                                                                            , inCode              := 2
                                                                                            , inProductId         := vbProductId
                                                                                            , inGoodsId           := 0
                                                                                            --, inProdColorGroupId  := vbProdColorGroupId3
                                                                                            --, inProdColorId       := vbColorId
                                                                                            , inProdColorPatternId:= vbProdColorPatternId
                                                                                            , inComment           := ''
                                                                                            , inSession           := inSession
                                                                                             ) AS tmp);
         END IF;

     END IF;

     -- 6.3.  ProdColorItemsId - Upholstery
     inUpholstery3:= TRIM (inUpholstery3);
     IF inUpholstery3 <> ''
     THEN
         vbProdColorPatternId:= 0;
         vbProdColorPatternName:= '3';
         -- Поиск - ProdColorPattern
         vbProdColorPatternId:= (SELECT Object.Id
                                 FROM ObjectLink AS OL_ProdColorGroup
                                      JOIN Object ON Object.Id = OL_ProdColorGroup.ObjectId
                                                 AND Object.ValueData ILIKE vbProdColorPatternName
                                 WHERE OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId3
                                   AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
                                );
         IF COALESCE (vbProdColorPatternId, 0) = 0
         THEN
             -- Создание
             vbProdColorPatternId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorPattern (ioId              := 0
                                                                                                , inCode            := 0
                                                                                                , inName            := vbProdColorPatternName
                                                                                                , inProdColorGroupId:= vbProdColorGroupId3
                                                                                                , inGoodsId         := 0
                                                                                                , ioComment         := ''
                                                                                                , ioProdColorName   := ''
                                                                                                , inSession         := inSession
                                                                                                 ) AS tmp);
         END IF;

         vbColorId:= 0;
         -- Поиск - Color
         vbColorId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inUpholstery3 AND Object.DescId = zc_Object_ProdColor());
         IF COALESCE (vbColorId, 0) = 0
         THEN
             -- Создание
             vbColorId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColor (ioId      := 0
                                                                              , ioCode    := 0
                                                                              , inName    := inUpholstery3
                                                                              , inComment := ''
                                                                              , inSession := inSession
                                                                               ) AS tmp);
         END IF;

         -- Поиск - Items
         vbProdColorItemsId:= (SELECT OL_Product.ObjectId
                               FROM ObjectLink AS OL_Product
                                    INNER JOIN ObjectLink AS OL_ProdColorGroup
                                                          ON OL_ProdColorGroup.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorItems_ProdColorGroup()
                                                         AND OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId3
                                    INNER JOIN Object AS Object_ProdColorItems
                                                      ON Object_ProdColorItems.Id         = OL_Product.ObjectId
                                                     AND Object_ProdColorItems.isErased   = FALSE
                                    INNER JOIN ObjectLink AS OL_ProdColorPattern
                                                          ON OL_ProdColorPattern.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorPattern.DescId        = zc_ObjectLink_ProdColorItems_ProdColorPattern()
                                                         AND OL_ProdColorPattern.ChildObjectId = vbProdColorPatternId
                               WHERE OL_Product.ChildObjectId = vbProductId
                                 AND OL_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                              );

         IF COALESCE (vbProdColorItemsId, 0) = 0 OR vbIsUpdate_ProdColorItems = TRUE
         THEN
             -- Создание
             vbProdColorItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorItems (ioId                := vbProdColorItemsId
                                                                                            , inCode              := 3
                                                                                            , inProductId         := vbProductId
                                                                                            , inGoodsId           := 0
                                                                                            --, inProdColorGroupId  := vbProdColorGroupId3
                                                                                            --, inProdColorId       := vbColorId
                                                                                            , inProdColorPatternId:= vbProdColorPatternId
                                                                                            , inComment           := ''
                                                                                            , inSession           := inSession
                                                                                             ) AS tmp);
         END IF;

     END IF;

     -- 6.4.  ProdColorItemsId - Upholstery
     inUpholstery4:= TRIM (inUpholstery4);
     IF inUpholstery4 <> ''
     THEN
         vbProdColorPatternId:= 0;
         vbProdColorPatternName:= '4';
         -- Поиск - ProdColorPattern
         vbProdColorPatternId:= (SELECT Object.Id
                                 FROM ObjectLink AS OL_ProdColorGroup
                                      JOIN Object ON Object.Id = OL_ProdColorGroup.ObjectId
                                                 AND Object.ValueData ILIKE vbProdColorPatternName
                                 WHERE OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId3
                                   AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
                                );
         IF COALESCE (vbProdColorPatternId, 0) = 0
         THEN
             -- Создание
             vbProdColorPatternId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorPattern (ioId              := 0
                                                                                                , inCode            := 0
                                                                                                , inName            := vbProdColorPatternName
                                                                                                , inProdColorGroupId:= vbProdColorGroupId3
                                                                                                , inGoodsId         := 0
                                                                                                , ioComment         := ''
                                                                                                , ioProdColorName   := ''
                                                                                                , inSession         := inSession
                                                                                                 ) AS tmp);
         END IF;

         vbColorId:= 0;
         -- Поиск - Color
         vbColorId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inUpholstery4 AND Object.DescId = zc_Object_ProdColor());
         IF COALESCE (vbColorId, 0) = 0
         THEN
             -- Создание
             vbColorId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColor (ioId      := 0
                                                                              , ioCode    := 0
                                                                              , inName    := inUpholstery4
                                                                              , inComment := ''
                                                                              , inSession := inSession
                                                                               ) AS tmp);
         END IF;

         -- Поиск - Items
         vbProdColorItemsId:= (SELECT OL_Product.ObjectId
                               FROM ObjectLink AS OL_Product
                                    INNER JOIN ObjectLink AS OL_ProdColorGroup
                                                          ON OL_ProdColorGroup.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorItems_ProdColorGroup()
                                                         AND OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId3
                                    INNER JOIN Object AS Object_ProdColorItems
                                                      ON Object_ProdColorItems.Id         = OL_Product.ObjectId
                                                     AND Object_ProdColorItems.isErased   = FALSE
                                    INNER JOIN ObjectLink AS OL_ProdColorPattern
                                                          ON OL_ProdColorPattern.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorPattern.DescId        = zc_ObjectLink_ProdColorItems_ProdColorPattern()
                                                         AND OL_ProdColorPattern.ChildObjectId = vbProdColorPatternId
                               WHERE OL_Product.ChildObjectId = vbProductId
                                 AND OL_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                              );

         IF COALESCE (vbProdColorItemsId, 0) = 0 OR vbIsUpdate_ProdColorItems = TRUE
         THEN
             -- Создание
             vbProdColorItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorItems (ioId                := vbProdColorItemsId
                                                                                            , inCode              := 4
                                                                                            , inProductId         := vbProductId
                                                                                            , inGoodsId           := 0
                                                                                            --, inProdColorGroupId  := vbProdColorGroupId3
                                                                                            --, inProdColorId       := vbColorId
                                                                                            , inProdColorPatternId:= vbProdColorPatternId
                                                                                            , inComment           := ''
                                                                                            , inSession           := inSession
                                                                                             ) AS tmp);
         END IF;

     END IF;


     -- 7.1.  ProdColorItemsId - StitchingColor + StitchingType
     inStitchingColor:= TRIM (inStitchingColor);
     IF inStitchingColor <> ''
     THEN
         vbProdColorPatternId:= 0;
         vbProdColorPatternName:= 'Color';
         -- Поиск - ProdColorPattern
         vbProdColorPatternId:= (SELECT Object.Id
                                 FROM ObjectLink AS OL_ProdColorGroup
                                      JOIN Object ON Object.Id = OL_ProdColorGroup.ObjectId
                                                 AND Object.ValueData ILIKE vbProdColorPatternName
                                 WHERE OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId4
                                   AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
                                );
         IF COALESCE (vbProdColorPatternId, 0) = 0
         THEN
             -- Создание
             vbProdColorPatternId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorPattern (ioId              := 0
                                                                                                , inCode            := 0
                                                                                                , inName            := vbProdColorPatternName
                                                                                                , inProdColorGroupId:= vbProdColorGroupId4
                                                                                                , inGoodsId         := 0
                                                                                                , ioComment         := ''
                                                                                                , ioProdColorName   := ''
                                                                                                , inSession         := inSession
                                                                                                 ) AS tmp);
         END IF;

         vbColorId:= 0;
         -- Поиск - Color
         vbColorId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inStitchingColor AND Object.DescId = zc_Object_ProdColor());
         IF COALESCE (vbColorId, 0) = 0
         THEN
             -- Создание
             vbColorId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColor (ioId      := 0
                                                                              , ioCode    := 0
                                                                              , inName    := inStitchingColor
                                                                              , inComment := ''
                                                                              , inSession := inSession
                                                                               ) AS tmp);
         END IF;

         -- Поиск - Items
         vbProdColorItemsId:= (SELECT OL_Product.ObjectId
                               FROM ObjectLink AS OL_Product
                                    INNER JOIN ObjectLink AS OL_ProdColorGroup
                                                          ON OL_ProdColorGroup.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorItems_ProdColorGroup()
                                                         AND OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId4
                                    INNER JOIN Object AS Object_ProdColorItems
                                                      ON Object_ProdColorItems.Id         = OL_Product.ObjectId
                                                     AND Object_ProdColorItems.isErased   = FALSE
                                    INNER JOIN ObjectLink AS OL_ProdColorPattern
                                                          ON OL_ProdColorPattern.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorPattern.DescId        = zc_ObjectLink_ProdColorItems_ProdColorPattern()
                                                         AND OL_ProdColorPattern.ChildObjectId = vbProdColorPatternId
                               WHERE OL_Product.ChildObjectId = vbProductId
                                 AND OL_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                              );

         IF COALESCE (vbProdColorItemsId, 0) = 0 OR vbIsUpdate_ProdColorItems = TRUE
         THEN
             -- Создание
             vbProdColorItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorItems (ioId                := vbProdColorItemsId
                                                                                            , inCode              := 1
                                                                                            , inProductId         := vbProductId
                                                                                            , inGoodsId           := 0
                                                                                            --, inProdColorGroupId  := vbProdColorGroupId4
                                                                                            --, inProdColorId       := vbColorId
                                                                                            , inProdColorPatternId:= vbProdColorPatternId
                                                                                            , inComment           := ''
                                                                                            , inSession           := inSession
                                                                                             ) AS tmp);
         END IF;

     END IF;

     -- 7.2.  ProdColorItemsId - StitchingColor + StitchingType
     inStitchingType:= TRIM (inStitchingType);
     IF inStitchingType <> ''
     THEN
         vbProdColorPatternId:= 0;
         vbProdColorPatternName:= 'Type';
         -- Поиск - ProdColorPattern
         vbProdColorPatternId:= (SELECT Object.Id
                                 FROM ObjectLink AS OL_ProdColorGroup
                                      JOIN Object ON Object.Id = OL_ProdColorGroup.ObjectId
                                                 AND Object.ValueData ILIKE vbProdColorPatternName
                                 WHERE OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId4
                                   AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
                                );
         IF COALESCE (vbProdColorPatternId, 0) = 0
         THEN
             -- Создание
             vbProdColorPatternId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorPattern (ioId              := 0
                                                                                                , inCode            := 0
                                                                                                , inName            := vbProdColorPatternName
                                                                                                , inProdColorGroupId:= vbProdColorGroupId4
                                                                                                , inGoodsId         := 0
                                                                                                , ioComment         := ''
                                                                                                , ioProdColorName   := ''
                                                                                                , inSession         := inSession
                                                                                                 ) AS tmp);
         END IF;

         vbColorId:= 0;
         -- Поиск - Color
         vbColorId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inStitchingType AND Object.DescId = zc_Object_ProdColor());
         IF COALESCE (vbColorId, 0) = 0
         THEN
             -- Создание
             vbColorId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColor (ioId      := 0
                                                                              , ioCode    := 0
                                                                              , inName    := inStitchingType
                                                                              , inComment := ''
                                                                              , inSession := inSession
                                                                               ) AS tmp);
         END IF;

         -- Поиск - Items
         vbProdColorItemsId:= (SELECT OL_Product.ObjectId
                               FROM ObjectLink AS OL_Product
                                    INNER JOIN ObjectLink AS OL_ProdColorGroup
                                                          ON OL_ProdColorGroup.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorItems_ProdColorGroup()
                                                         AND OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId4
                                    INNER JOIN Object AS Object_ProdColorItems
                                                      ON Object_ProdColorItems.Id         = OL_Product.ObjectId
                                                     AND Object_ProdColorItems.isErased   = FALSE
                                    INNER JOIN ObjectLink AS OL_ProdColorPattern
                                                          ON OL_ProdColorPattern.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorPattern.DescId        = zc_ObjectLink_ProdColorItems_ProdColorPattern()
                                                         AND OL_ProdColorPattern.ChildObjectId = vbProdColorPatternId
                               WHERE OL_Product.ChildObjectId = vbProductId
                                 AND OL_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                              );

         IF COALESCE (vbProdColorItemsId, 0) = 0 OR vbIsUpdate_ProdColorItems = TRUE
         THEN
             -- Создание
             vbProdColorItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorItems (ioId                := vbProdColorItemsId
                                                                                            , inCode              := 2
                                                                                            , inProductId         := vbProductId
                                                                                            , inGoodsId           := 0
                                                                                            --, inProdColorGroupId  := vbProdColorGroupId4
                                                                                            --, inProdColorId       := vbColorId
                                                                                            , inProdColorPatternId:= vbProdColorPatternId
                                                                                            , inComment           := ''
                                                                                            , inSession           := inSession
                                                                                             ) AS tmp);
         END IF;

     END IF;


     -- 8.1.  ProdColorItemsId - Color
     inColor1:= TRIM (inColor1);
     IF inColor1 <> ''
     THEN
         vbProdColorPatternId:= 0;
         vbProdColorPatternName:= '1';
         -- Поиск - ProdColorPattern
         vbProdColorPatternId:= (SELECT Object.Id
                                 FROM ObjectLink AS OL_ProdColorGroup
                                      JOIN Object ON Object.Id = OL_ProdColorGroup.ObjectId
                                                 AND Object.ValueData ILIKE vbProdColorPatternName
                                 WHERE OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId5
                                   AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
                                );
         IF COALESCE (vbProdColorPatternId, 0) = 0
         THEN
             -- Создание
             vbProdColorPatternId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorPattern (ioId              := 0
                                                                                                , inCode            := 0
                                                                                                , inName            := vbProdColorPatternName
                                                                                                , inProdColorGroupId:= vbProdColorGroupId5
                                                                                                , inGoodsId         := 0
                                                                                                , ioComment         := ''
                                                                                                , ioProdColorName   := ''
                                                                                                , inSession         := inSession
                                                                                                 ) AS tmp);
         END IF;

         vbColorId:= 0;
         -- Поиск - Color
         vbColorId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inColor1 AND Object.DescId = zc_Object_ProdColor());
         IF COALESCE (vbColorId, 0) = 0
         THEN
             -- Создание
             vbColorId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColor (ioId      := 0
                                                                              , ioCode    := 0
                                                                              , inName    := inColor1
                                                                              , inComment := ''
                                                                              , inSession := inSession
                                                                               ) AS tmp);
         END IF;

         -- Поиск - Items
         vbProdColorItemsId:= (SELECT OL_Product.ObjectId
                               FROM ObjectLink AS OL_Product
                                    INNER JOIN ObjectLink AS OL_ProdColorGroup
                                                          ON OL_ProdColorGroup.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorItems_ProdColorGroup()
                                                         AND OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId5
                                    INNER JOIN Object AS Object_ProdColorItems
                                                      ON Object_ProdColorItems.Id         = OL_Product.ObjectId
                                                     AND Object_ProdColorItems.isErased   = FALSE
                                    INNER JOIN ObjectLink AS OL_ProdColorPattern
                                                          ON OL_ProdColorPattern.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorPattern.DescId        = zc_ObjectLink_ProdColorItems_ProdColorPattern()
                                                         AND OL_ProdColorPattern.ChildObjectId = vbProdColorPatternId
                               WHERE OL_Product.ChildObjectId = vbProductId
                                 AND OL_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                              );

         IF COALESCE (vbProdColorItemsId, 0) = 0 OR vbIsUpdate_ProdColorItems = TRUE
         THEN
             -- Создание
             vbProdColorItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorItems (ioId                := vbProdColorItemsId
                                                                                            , inCode              := 1
                                                                                            , inProductId         := vbProductId
                                                                                            , inGoodsId           := 0
                                                                                            --, inProdColorGroupId  := vbProdColorGroupId5
                                                                                            --, inProdColorId       := vbColorId
                                                                                            , inProdColorPatternId:= vbProdColorPatternId
                                                                                            , inComment           := ''
                                                                                            , inSession           := inSession
                                                                                             ) AS tmp);
         END IF;

     END IF;


     -- 8.2.  ProdColorItemsId - Color
     inColor2:= TRIM (inColor2);
     IF inColor2 <> ''
     THEN
         vbProdColorPatternId:= 0;
         vbProdColorPatternName:= '2';
         -- Поиск - ProdColorPattern
         vbProdColorPatternId:= (SELECT Object.Id
                                 FROM ObjectLink AS OL_ProdColorGroup
                                      JOIN Object ON Object.Id = OL_ProdColorGroup.ObjectId
                                                 AND Object.ValueData ILIKE vbProdColorPatternName
                                 WHERE OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId5
                                   AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
                                );
         IF COALESCE (vbProdColorPatternId, 0) = 0
         THEN
             -- Создание
             vbProdColorPatternId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorPattern (ioId              := 0
                                                                                                , inCode            := 0
                                                                                                , inName            := vbProdColorPatternName
                                                                                                , inProdColorGroupId:= vbProdColorGroupId5
                                                                                                , inGoodsId         := 0
                                                                                                , ioComment         := ''
                                                                                                , ioProdColorName   := ''
                                                                                                , inSession         := inSession
                                                                                                 ) AS tmp);
         END IF;

         vbColorId:= 0;
         -- Поиск - Color
         vbColorId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inColor2 AND Object.DescId = zc_Object_ProdColor());
         IF COALESCE (vbColorId, 0) = 0
         THEN
             -- Создание
             vbColorId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColor (ioId      := 0
                                                                              , ioCode    := 0
                                                                              , inName    := inColor2
                                                                              , inComment := ''
                                                                              , inSession := inSession
                                                                               ) AS tmp);
         END IF;

         -- Поиск - Items
         vbProdColorItemsId:= (SELECT OL_Product.ObjectId
                               FROM ObjectLink AS OL_Product
                                    INNER JOIN ObjectLink AS OL_ProdColorGroup
                                                          ON OL_ProdColorGroup.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorItems_ProdColorGroup()
                                                         AND OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId5
                                    INNER JOIN Object AS Object_ProdColorItems
                                                      ON Object_ProdColorItems.Id         = OL_Product.ObjectId
                                                     AND Object_ProdColorItems.isErased   = FALSE
                                    INNER JOIN ObjectLink AS OL_ProdColorPattern
                                                          ON OL_ProdColorPattern.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorPattern.DescId        = zc_ObjectLink_ProdColorItems_ProdColorPattern()
                                                         AND OL_ProdColorPattern.ChildObjectId = vbProdColorPatternId
                               WHERE OL_Product.ChildObjectId = vbProductId
                                 AND OL_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                              );

         IF COALESCE (vbProdColorItemsId, 0) = 0 OR vbIsUpdate_ProdColorItems = TRUE
         THEN
             -- Создание
             vbProdColorItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorItems (ioId                := vbProdColorItemsId
                                                                                            , inCode              := 2
                                                                                            , inProductId         := vbProductId
                                                                                            , inGoodsId           := 0
                                                                                            --, inProdColorGroupId  := vbProdColorGroupId5
                                                                                            --, inProdColorId       := vbColorId
                                                                                            , inProdColorPatternId:= vbProdColorPatternId
                                                                                            , inComment           := ''
                                                                                            , inSession           := inSession
                                                                                             ) AS tmp);
         END IF;

     END IF;

     -- 8.3.  ProdColorItemsId - Color
     inColor3:= TRIM (inColor3);
     IF inColor3 <> ''
     THEN
         vbProdColorPatternId:= 0;
         vbProdColorPatternName:= '3';
         -- Поиск - ProdColorPattern
         vbProdColorPatternId:= (SELECT Object.Id
                                 FROM ObjectLink AS OL_ProdColorGroup
                                      JOIN Object ON Object.Id = OL_ProdColorGroup.ObjectId
                                                 AND Object.ValueData ILIKE vbProdColorPatternName
                                 WHERE OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId5
                                   AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
                                );
         IF COALESCE (vbProdColorPatternId, 0) = 0
         THEN
             -- Создание
             vbProdColorPatternId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorPattern (ioId              := 0
                                                                                                , inCode            := 0
                                                                                                , inName            := vbProdColorPatternName
                                                                                                , inProdColorGroupId:= vbProdColorGroupId5
                                                                                                , inGoodsId         := 0
                                                                                                , ioComment         := ''
                                                                                                , ioProdColorName   := ''
                                                                                                , inSession         := inSession
                                                                                                 ) AS tmp);
         END IF;

         vbColorId:= 0;
         -- Поиск - Color
         vbColorId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inColor3 AND Object.DescId = zc_Object_ProdColor());
         IF COALESCE (vbColorId, 0) = 0
         THEN
             -- Создание
             vbColorId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColor (ioId      := 0
                                                                              , ioCode    := 0
                                                                              , inName    := inColor3
                                                                              , inComment := ''
                                                                              , inSession := inSession
                                                                               ) AS tmp);
         END IF;

         -- Поиск - Items
         vbProdColorItemsId:= (SELECT OL_Product.ObjectId
                               FROM ObjectLink AS OL_Product
                                    INNER JOIN ObjectLink AS OL_ProdColorGroup
                                                          ON OL_ProdColorGroup.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorItems_ProdColorGroup()
                                                         AND OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId5
                                    INNER JOIN Object AS Object_ProdColorItems
                                                      ON Object_ProdColorItems.Id         = OL_Product.ObjectId
                                                     AND Object_ProdColorItems.isErased   = FALSE
                                    INNER JOIN ObjectLink AS OL_ProdColorPattern
                                                          ON OL_ProdColorPattern.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorPattern.DescId        = zc_ObjectLink_ProdColorItems_ProdColorPattern()
                                                         AND OL_ProdColorPattern.ChildObjectId = vbProdColorPatternId
                               WHERE OL_Product.ChildObjectId = vbProductId
                                 AND OL_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                              );

         IF COALESCE (vbProdColorItemsId, 0) = 0 OR vbIsUpdate_ProdColorItems = TRUE
         THEN
             -- Создание
             vbProdColorItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorItems (ioId                := vbProdColorItemsId
                                                                                            , inCode              := 3
                                                                                            , inProductId         := vbProductId
                                                                                            , inGoodsId           := 0
                                                                                            --, inProdColorGroupId  := vbProdColorGroupId5
                                                                                            --, inProdColorId       := vbColorId
                                                                                            , inProdColorPatternId:= vbProdColorPatternId
                                                                                            , inComment           := ''
                                                                                            , inSession           := inSession
                                                                                             ) AS tmp);
         END IF;

     END IF;

     -- 8.4.  ProdColorItemsId - Color
     inColor4:= TRIM (inColor4);
     IF inColor4 <> ''
     THEN
         vbProdColorPatternId:= 0;
         vbProdColorPatternName:= '4';
         -- Поиск - ProdColorPattern
         vbProdColorPatternId:= (SELECT Object.Id
                                 FROM ObjectLink AS OL_ProdColorGroup
                                      JOIN Object ON Object.Id = OL_ProdColorGroup.ObjectId
                                                 AND Object.ValueData ILIKE vbProdColorPatternName
                                 WHERE OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId5
                                   AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
                                );
         IF COALESCE (vbProdColorPatternId, 0) = 0
         THEN
             -- Создание
             vbProdColorPatternId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorPattern (ioId              := 0
                                                                                                , inCode            := 0
                                                                                                , inName            := vbProdColorPatternName
                                                                                                , inProdColorGroupId:= vbProdColorGroupId5
                                                                                                , inGoodsId         := 0
                                                                                                , ioComment         := ''
                                                                                                , ioProdColorName   := ''
                                                                                                , inSession         := inSession
                                                                                                 ) AS tmp);
         END IF;

         vbColorId:= 0;
         -- Поиск - Color
         vbColorId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inColor4 AND Object.DescId = zc_Object_ProdColor());
         IF COALESCE (vbColorId, 0) = 0
         THEN
             -- Создание
             vbColorId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColor (ioId      := 0
                                                                              , ioCode    := 0
                                                                              , inName    := inColor4
                                                                              , inComment := ''
                                                                              , inSession := inSession
                                                                               ) AS tmp);
         END IF;

         -- Поиск - Items
         vbProdColorItemsId:= (SELECT OL_Product.ObjectId
                               FROM ObjectLink AS OL_Product
                                    INNER JOIN ObjectLink AS OL_ProdColorGroup
                                                          ON OL_ProdColorGroup.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorItems_ProdColorGroup()
                                                         AND OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId5
                                    INNER JOIN Object AS Object_ProdColorItems
                                                      ON Object_ProdColorItems.Id         = OL_Product.ObjectId
                                                     AND Object_ProdColorItems.isErased   = FALSE
                                    INNER JOIN ObjectLink AS OL_ProdColorPattern
                                                          ON OL_ProdColorPattern.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorPattern.DescId        = zc_ObjectLink_ProdColorItems_ProdColorPattern()
                                                         AND OL_ProdColorPattern.ChildObjectId = vbProdColorPatternId
                               WHERE OL_Product.ChildObjectId = vbProductId
                                 AND OL_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                              );

         IF COALESCE (vbProdColorItemsId, 0) = 0 OR vbIsUpdate_ProdColorItems = TRUE
         THEN
             -- Создание
             vbProdColorItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorItems (ioId                := vbProdColorItemsId
                                                                                            , inCode              := 4
                                                                                            , inProductId         := vbProductId
                                                                                            , inGoodsId           := 0
                                                                                            --, inProdColorGroupId  := vbProdColorGroupId5
                                                                                            --, inProdColorId       := vbColorId
                                                                                            , inProdColorPatternId:= vbProdColorPatternId
                                                                                            , inComment           := ''
                                                                                            , inSession           := inSession
                                                                                             ) AS tmp);
         END IF;

     END IF;

     -- 8.5.  ProdColorItemsId - Color
     inColor5:= TRIM (inColor5);
     IF inColor5 <> ''
     THEN
         vbProdColorPatternId:= 0;
         vbProdColorPatternName:= '5';
         -- Поиск - ProdColorPattern
         vbProdColorPatternId:= (SELECT Object.Id
                                 FROM ObjectLink AS OL_ProdColorGroup
                                      JOIN Object ON Object.Id = OL_ProdColorGroup.ObjectId
                                                 AND Object.ValueData ILIKE vbProdColorPatternName
                                 WHERE OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId5
                                   AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
                                );
         IF COALESCE (vbProdColorPatternId, 0) = 0
         THEN
             -- Создание
             vbProdColorPatternId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorPattern (ioId              := 0
                                                                                                , inCode            := 0
                                                                                                , inName            := vbProdColorPatternName
                                                                                                , inProdColorGroupId:= vbProdColorGroupId5
                                                                                                , inGoodsId         := 0
                                                                                                , ioComment         := ''
                                                                                                , ioProdColorName   := ''
                                                                                                , inSession         := inSession
                                                                                                 ) AS tmp);
         END IF;

         vbColorId:= 0;
         -- Поиск - Color
         vbColorId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inColor5 AND Object.DescId = zc_Object_ProdColor());
         IF COALESCE (vbColorId, 0) = 0
         THEN
             -- Создание
             vbColorId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColor (ioId      := 0
                                                                              , ioCode    := 0
                                                                              , inName    := inColor5
                                                                              , inComment := ''
                                                                              , inSession := inSession
                                                                               ) AS tmp);
         END IF;

         -- Поиск - Items
         vbProdColorItemsId:= (SELECT OL_Product.ObjectId
                               FROM ObjectLink AS OL_Product
                                    INNER JOIN ObjectLink AS OL_ProdColorGroup
                                                          ON OL_ProdColorGroup.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorItems_ProdColorGroup()
                                                         AND OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId5
                                    INNER JOIN Object AS Object_ProdColorItems
                                                      ON Object_ProdColorItems.Id         = OL_Product.ObjectId
                                                     AND Object_ProdColorItems.isErased   = FALSE
                                    INNER JOIN ObjectLink AS OL_ProdColorPattern
                                                          ON OL_ProdColorPattern.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorPattern.DescId        = zc_ObjectLink_ProdColorItems_ProdColorPattern()
                                                         AND OL_ProdColorPattern.ChildObjectId = vbProdColorPatternId
                               WHERE OL_Product.ChildObjectId = vbProductId
                                 AND OL_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                              );

         IF COALESCE (vbProdColorItemsId, 0) = 0 OR vbIsUpdate_ProdColorItems = TRUE
         THEN
             -- Создание
             vbProdColorItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorItems (ioId                := vbProdColorItemsId
                                                                                            , inCode              := 5
                                                                                            , inProductId         := vbProductId
                                                                                            , inGoodsId           := 0
                                                                                            --, inProdColorGroupId  := vbProdColorGroupId5
                                                                                            --, inProdColorId       := vbColorId
                                                                                            , inProdColorPatternId:= vbProdColorPatternId
                                                                                            , inComment           := ''
                                                                                            , inSession           := inSession
                                                                                             ) AS tmp);
         END IF;

     END IF;


     -- 9.1.  ProdOptItemsId
     inOptionName1:= TRIM (inOptionName1);
     IF inOptionName1 <> ''
     THEN
         vbProdOptPatternId:= 0;
         vbProdOptPatternName:= 'Option 1';
         -- Поиск - ProdOptPattern
         vbProdOptPatternId:= (SELECT Object_ProdOptPattern.Id
                               FROM Object AS Object_ProdOptPattern
                               WHERE Object_ProdOptPattern.DescId    = zc_Object_ProdOptPattern()
                                 AND Object_ProdOptPattern.ValueData ILIKE vbProdOptPatternName
                              );
         IF COALESCE (vbProdOptPatternId, 0) = 0
         THEN
             -- Создание
             vbProdOptPatternId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdOptPattern (ioId              := 0
                                                                                            , inCode            := 0
                                                                                            , inName            := vbProdOptPatternName
                                                                                            , inComment         := ''
                                                                                            , inSession         := inSession
                                                                                             ) AS tmp);
         END IF;

         vbProdOptionsId:= 0;
         -- Поиск - Options
         vbProdOptionsId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inOptionName1 AND Object.DescId = zc_Object_ProdOptions());
         IF COALESCE (vbProdOptionsId, 0) = 0
         THEN
             -- Создание
             vbProdOptionsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdOptions (ioId      := 0
                                                                                      , inCode    := 0
                                                                                      , inName    := inOptionName1
                                                                                      , inLevel   := 1
                                                                                      , inComment := ''
                                                                                      , inSession := inSession
                                                                                       ) AS tmp);
         END IF;

         -- Поиск - Items
         vbProdOptItemsId:= (SELECT OL_Product.ObjectId
                             FROM ObjectLink AS OL_Product
                                  INNER JOIN Object AS Object_ProdOptItems
                                                    ON Object_ProdOptItems.Id         = OL_Product.ObjectId
                                                   AND Object_ProdOptItems.isErased   = FALSE
                                  INNER JOIN ObjectLink AS OL_ProdOptPattern
                                                        ON OL_ProdOptPattern.ObjectId      = OL_Product.ObjectId
                                                       AND OL_ProdOptPattern.DescId        = zc_ObjectLink_ProdOptItems_ProdOptPattern()
                                                       AND OL_ProdOptPattern.ChildObjectId = vbProdOptPatternId
                             WHERE OL_Product.ChildObjectId = vbProductId
                               AND OL_Product.DescId        = zc_ObjectLink_ProdOptItems_Product()
                            );
         IF COALESCE (vbProdOptItemsId, 0) = 0
         THEN
             -- Создание
             vbProdOptItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdOptItems (ioId              := 0
                                                                                        , inCode            := 1
                                                                                        , inProductId       := vbProductId
                                                                                        , inProdOptionsId   := vbProdOptionsId
                                                                                        , inProdOptPatternId:= vbProdOptPatternId
                                                                                        , inPriceIn         := inOptionPrice1 * 0.75
                                                                                        , inPriceOut        := inOptionPrice1
                                                                                        , inPartNumber      := inOptionPartNumber1
                                                                                        , inComment         := ''
                                                                                        , inSession         := inSession
                                                                                         ) AS tmp);
         END IF;

     END IF;

     -- 9.2.  ProdOptItemsId
     inOptionName2:= TRIM (inOptionName2);
     IF inOptionName2 <> ''
     THEN
         vbProdOptPatternId:= 0;
         vbProdOptPatternName:= 'Option 2';
         -- Поиск - ProdOptPattern
         vbProdOptPatternId:= (SELECT Object_ProdOptPattern.Id
                                 FROM Object AS Object_ProdOptPattern
                                 WHERE Object_ProdOptPattern.DescId    = zc_Object_ProdOptPattern()
                                   AND Object_ProdOptPattern.ValueData ILIKE vbProdOptPatternName
                                );
         IF COALESCE (vbProdOptPatternId, 0) = 0
         THEN
             -- Создание
             vbProdOptPatternId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdOptPattern (ioId              := 0
                                                                                            , inCode            := 0
                                                                                            , inName            := vbProdOptPatternName
                                                                                            , inComment         := ''
                                                                                            , inSession         := inSession
                                                                                             ) AS tmp);
         END IF;

         vbProdOptionsId:= 0;
         -- Поиск - Options
         vbProdOptionsId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inOptionName2 AND Object.DescId = zc_Object_ProdOptions());
         IF COALESCE (vbProdOptionsId, 0) = 0
         THEN
             -- Создание
             vbProdOptionsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdOptions (ioId      := 0
                                                                                      , inCode    := 0
                                                                                      , inName    := inOptionName2
                                                                                      , inLevel   := 2
                                                                                      , inComment := ''
                                                                                      , inSession := inSession
                                                                                       ) AS tmp);
         END IF;

         -- Поиск - Items
         vbProdOptItemsId:= (SELECT OL_Product.ObjectId
                             FROM ObjectLink AS OL_Product
                                  INNER JOIN Object AS Object_ProdOptItems
                                                    ON Object_ProdOptItems.Id       = OL_Product.ObjectId
                                                   AND Object_ProdOptItems.isErased = FALSE
                                  INNER JOIN ObjectLink AS OL_ProdOptPattern
                                                        ON OL_ProdOptPattern.ObjectId      = OL_Product.ObjectId
                                                       AND OL_ProdOptPattern.DescId        = zc_ObjectLink_ProdOptItems_ProdOptPattern()
                                                       AND OL_ProdOptPattern.ChildObjectId = vbProdOptPatternId
                             WHERE OL_Product.ChildObjectId = vbProductId
                               AND OL_Product.DescId        = zc_ObjectLink_ProdOptItems_Product()
                            );
         IF COALESCE (vbProdOptItemsId, 0) = 0
         THEN
             -- Создание
             vbProdOptItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdOptItems (ioId              := 0
                                                                                        , inCode            := 2
                                                                                        , inProductId       := vbProductId
                                                                                        , inProdOptionsId   := vbProdOptionsId
                                                                                        , inProdOptPatternId:= vbProdOptPatternId
                                                                                        , inPriceIn         := inOptionPrice2 * 0.75
                                                                                        , inPriceOut        := inOptionPrice2
                                                                                        , inPartNumber      := inOptionPartNumber2
                                                                                        , inComment         := ''
                                                                                        , inSession         := inSession
                                                                                         ) AS tmp);
         END IF;

     END IF;


     -- 9.3.  ProdOptItemsId
     inOptionName3:= TRIM (inOptionName3);
     IF inOptionName3 <> ''
     THEN
         vbProdOptPatternId:= 0;
         vbProdOptPatternName:= 'Option 3';
         -- Поиск - ProdOptPattern
         vbProdOptPatternId:= (SELECT Object_ProdOptPattern.Id
                                 FROM Object AS Object_ProdOptPattern
                                 WHERE Object_ProdOptPattern.DescId    = zc_Object_ProdOptPattern()
                                   AND Object_ProdOptPattern.ValueData ILIKE vbProdOptPatternName
                                );
         IF COALESCE (vbProdOptPatternId, 0) = 0
         THEN
             -- Создание
             vbProdOptPatternId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdOptPattern (ioId              := 0
                                                                                            , inCode            := 0
                                                                                            , inName            := vbProdOptPatternName
                                                                                            , inComment         := ''
                                                                                            , inSession         := inSession
                                                                                             ) AS tmp);
         END IF;

         vbProdOptionsId:= 0;
         -- Поиск - Options
         vbProdOptionsId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inOptionName3 AND Object.DescId = zc_Object_ProdOptions());
         IF COALESCE (vbProdOptionsId, 0) = 0
         THEN
             -- Создание
             vbProdOptionsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdOptions (ioId      := 0
                                                                                      , inCode    := 0
                                                                                      , inName    := inOptionName3
                                                                                      , inLevel   := 3
                                                                                      , inComment := ''
                                                                                      , inSession := inSession
                                                                                       ) AS tmp);
         END IF;

         -- Поиск - Items
         vbProdOptItemsId:= (SELECT OL_Product.ObjectId
                             FROM ObjectLink AS OL_Product
                                  INNER JOIN Object AS Object_ProdOptItems
                                                    ON Object_ProdOptItems.Id       = OL_Product.ObjectId
                                                   AND Object_ProdOptItems.isErased = FALSE
                                  INNER JOIN ObjectLink AS OL_ProdOptPattern
                                                        ON OL_ProdOptPattern.ObjectId      = OL_Product.ObjectId
                                                       AND OL_ProdOptPattern.DescId        = zc_ObjectLink_ProdOptItems_ProdOptPattern()
                                                       AND OL_ProdOptPattern.ChildObjectId = vbProdOptPatternId
                             WHERE OL_Product.ChildObjectId = vbProductId
                               AND OL_Product.DescId        = zc_ObjectLink_ProdOptItems_Product()
                            );
         IF COALESCE (vbProdOptItemsId, 0) = 0
         THEN
             -- Создание
             vbProdOptItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdOptItems (ioId              := 0
                                                                                        , inCode            := 3
                                                                                        , inProductId       := vbProductId
                                                                                        , inProdOptionsId   := vbProdOptionsId
                                                                                        , inProdOptPatternId:= vbProdOptPatternId
                                                                                        , inPriceIn         := inOptionPrice3 * 0.75
                                                                                        , inPriceOut        := inOptionPrice3
                                                                                        , inPartNumber      := inOptionPartNumber3
                                                                                        , inComment         := ''
                                                                                        , inSession         := inSession
                                                                                         ) AS tmp);
         END IF;

     END IF;

     -- 9.4.  ProdOptItemsId
     inOptionName4:= TRIM (inOptionName4);
     IF inOptionName4 <> ''
     THEN
         vbProdOptPatternId:= 0;
         vbProdOptPatternName:= 'Option 4';
         -- Поиск - ProdOptPattern
         vbProdOptPatternId:= (SELECT Object_ProdOptPattern.Id
                                 FROM Object AS Object_ProdOptPattern
                                 WHERE Object_ProdOptPattern.DescId    = zc_Object_ProdOptPattern()
                                   AND Object_ProdOptPattern.ValueData ILIKE vbProdOptPatternName
                                );
         IF COALESCE (vbProdOptPatternId, 0) = 0
         THEN
             -- Создание
             vbProdOptPatternId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdOptPattern (ioId              := 0
                                                                                            , inCode            := 0
                                                                                            , inName            := vbProdOptPatternName
                                                                                            , inComment         := ''
                                                                                            , inSession         := inSession
                                                                                             ) AS tmp);
         END IF;

         vbProdOptionsId:= 0;
         -- Поиск - Options
         vbProdOptionsId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inOptionName4 AND Object.DescId = zc_Object_ProdOptions());
         IF COALESCE (vbProdOptionsId, 0) = 0
         THEN
             -- Создание
             vbProdOptionsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdOptions (ioId      := 0
                                                                                      , inCode    := 0
                                                                                      , inName    := inOptionName4
                                                                                      , inLevel   := 4
                                                                                      , inComment := ''
                                                                                      , inSession := inSession
                                                                                       ) AS tmp);
         END IF;

         -- Поиск - Items
         vbProdOptItemsId:= (SELECT OL_Product.ObjectId
                             FROM ObjectLink AS OL_Product
                                  INNER JOIN Object AS Object_ProdOptItems
                                                    ON Object_ProdOptItems.Id       = OL_Product.ObjectId
                                                   AND Object_ProdOptItems.isErased = FALSE
                                  INNER JOIN ObjectLink AS OL_ProdOptPattern
                                                        ON OL_ProdOptPattern.ObjectId      = OL_Product.ObjectId
                                                       AND OL_ProdOptPattern.DescId        = zc_ObjectLink_ProdOptItems_ProdOptPattern()
                                                       AND OL_ProdOptPattern.ChildObjectId = vbProdOptPatternId
                             WHERE OL_Product.ChildObjectId = vbProductId
                               AND OL_Product.DescId        = zc_ObjectLink_ProdOptItems_Product()
                            );
         IF COALESCE (vbProdOptItemsId, 0) = 0
         THEN
             -- Создание
             vbProdOptItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdOptItems (ioId              := 0
                                                                                        , inCode            := 4
                                                                                        , inProductId       := vbProductId
                                                                                        , inProdOptionsId   := vbProdOptionsId
                                                                                        , inProdOptPatternId:= vbProdOptPatternId
                                                                                        , inPriceIn         := inOptionPrice4 * 0.75
                                                                                        , inPriceOut        := inOptionPrice4
                                                                                        , inPartNumber      := inOptionPartNumber4
                                                                                        , inComment         := ''
                                                                                        , inSession         := inSession
                                                                                         ) AS tmp);
         END IF;

     END IF;

     -- 9.5.  ProdOptItemsId
     inOptionName5:= TRIM (inOptionName5);
     IF inOptionName5 <> ''
     THEN
         vbProdOptPatternId:= 0;
         vbProdOptPatternName:= 'Option 5';
         -- Поиск - ProdOptPattern
         vbProdOptPatternId:= (SELECT Object_ProdOptPattern.Id
                                 FROM Object AS Object_ProdOptPattern
                                 WHERE Object_ProdOptPattern.DescId    = zc_Object_ProdOptPattern()
                                   AND Object_ProdOptPattern.ValueData ILIKE vbProdOptPatternName
                                );
         IF COALESCE (vbProdOptPatternId, 0) = 0
         THEN
             -- Создание
             vbProdOptPatternId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdOptPattern (ioId              := 0
                                                                                            , inCode            := 0
                                                                                            , inName            := vbProdOptPatternName
                                                                                            , inComment         := ''
                                                                                            , inSession         := inSession
                                                                                             ) AS tmp);
         END IF;

         vbProdOptionsId:= 0;
         -- Поиск - Options
         vbProdOptionsId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inOptionName5 AND Object.DescId = zc_Object_ProdOptions());
         IF COALESCE (vbProdOptionsId, 0) = 0
         THEN
             -- Создание
             vbProdOptionsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdOptions (ioId      := 0
                                                                                      , inCode    := 0
                                                                                      , inName    := inOptionName5
                                                                                      , inLevel   := 5
                                                                                      , inComment := ''
                                                                                      , inSession := inSession
                                                                                       ) AS tmp);
         END IF;

         -- Поиск - Items
         vbProdOptItemsId:= (SELECT OL_Product.ObjectId
                             FROM ObjectLink AS OL_Product
                                  INNER JOIN Object AS Object_ProdOptItems
                                                    ON Object_ProdOptItems.Id       = OL_Product.ObjectId
                                                   AND Object_ProdOptItems.isErased = FALSE
                                  INNER JOIN ObjectLink AS OL_ProdOptPattern
                                                        ON OL_ProdOptPattern.ObjectId      = OL_Product.ObjectId
                                                       AND OL_ProdOptPattern.DescId        = zc_ObjectLink_ProdOptItems_ProdOptPattern()
                                                       AND OL_ProdOptPattern.ChildObjectId = vbProdOptPatternId
                             WHERE OL_Product.ChildObjectId = vbProductId
                               AND OL_Product.DescId        = zc_ObjectLink_ProdOptItems_Product()
                            );
         IF COALESCE (vbProdOptItemsId, 0) = 0
         THEN
             -- Создание
             vbProdOptItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdOptItems (ioId              := 0
                                                                                        , inCode            := 5
                                                                                        , inProductId       := vbProductId
                                                                                        , inProdOptionsId   := vbProdOptionsId
                                                                                        , inProdOptPatternId:= vbProdOptPatternId
                                                                                        , inPriceIn         := inOptionPrice5 * 0.75
                                                                                        , inPriceOut        := inOptionPrice5
                                                                                        , inPartNumber      := inOptionPartNumber5
                                                                                        , inComment         := ''
                                                                                        , inSession         := inSession
                                                                                         ) AS tmp);
         END IF;

     END IF;

     -- 9.6.  ProdOptItemsId
     inOptionName6:= TRIM (inOptionName6);
     IF inOptionName6 <> ''
     THEN
         vbProdOptPatternId:= 0;
         vbProdOptPatternName:= 'Option 6';
         -- Поиск - ProdOptPattern
         vbProdOptPatternId:= (SELECT Object_ProdOptPattern.Id
                                 FROM Object AS Object_ProdOptPattern
                                 WHERE Object_ProdOptPattern.DescId    = zc_Object_ProdOptPattern()
                                   AND Object_ProdOptPattern.ValueData ILIKE vbProdOptPatternName
                                );
         IF COALESCE (vbProdOptPatternId, 0) = 0
         THEN
             -- Создание
             vbProdOptPatternId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdOptPattern (ioId              := 0
                                                                                            , inCode            := 0
                                                                                            , inName            := vbProdOptPatternName
                                                                                            , inComment         := ''
                                                                                            , inSession         := inSession
                                                                                             ) AS tmp);
         END IF;

         vbProdOptionsId:= 0;
         -- Поиск - Options
         vbProdOptionsId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inOptionName6 AND Object.DescId = zc_Object_ProdOptions());
         IF COALESCE (vbProdOptionsId, 0) = 0
         THEN
             -- Создание
             vbProdOptionsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdOptions (ioId      := 0
                                                                                      , inCode    := 0
                                                                                      , inName    := inOptionName6
                                                                                      , inLevel   := 6
                                                                                      , inComment := ''
                                                                                      , inSession := inSession
                                                                                       ) AS tmp);
         END IF;

         -- Поиск - Items
         vbProdOptItemsId:= (SELECT OL_Product.ObjectId
                             FROM ObjectLink AS OL_Product
                                  INNER JOIN Object AS Object_ProdOptItems
                                                    ON Object_ProdOptItems.Id       = OL_Product.ObjectId
                                                   AND Object_ProdOptItems.isErased = FALSE
                                  INNER JOIN ObjectLink AS OL_ProdOptPattern
                                                        ON OL_ProdOptPattern.ObjectId      = OL_Product.ObjectId
                                                       AND OL_ProdOptPattern.DescId        = zc_ObjectLink_ProdOptItems_ProdOptPattern()
                                                       AND OL_ProdOptPattern.ChildObjectId = vbProdOptPatternId
                             WHERE OL_Product.ChildObjectId = vbProductId
                               AND OL_Product.DescId        = zc_ObjectLink_ProdOptItems_Product()
                            );
         IF COALESCE (vbProdOptItemsId, 0) = 0
         THEN
             -- Создание
             vbProdOptItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdOptItems (ioId              := 0
                                                                                        , inCode            := 6
                                                                                        , inProductId       := vbProductId
                                                                                        , inProdOptionsId   := vbProdOptionsId
                                                                                        , inProdOptPatternId:= vbProdOptPatternId
                                                                                        , inPriceIn         := inOptionPrice6 * 0.75
                                                                                        , inPriceOut        := inOptionPrice6
                                                                                        , inPartNumber      := inOptionPartNumber6
                                                                                        , inComment         := ''
                                                                                        , inSession         := inSession
                                                                                         ) AS tmp);
         END IF;

     END IF;

     -- 9.7.  ProdOptItemsId
     inOptionName7:= TRIM (inOptionName7);
     IF inOptionName7 <> ''
     THEN
         vbProdOptPatternId:= 0;
         vbProdOptPatternName:= 'Option 7';
         -- Поиск - ProdOptPattern
         vbProdOptPatternId:= (SELECT Object_ProdOptPattern.Id
                                 FROM Object AS Object_ProdOptPattern
                                 WHERE Object_ProdOptPattern.DescId    = zc_Object_ProdOptPattern()
                                   AND Object_ProdOptPattern.ValueData ILIKE vbProdOptPatternName
                                );
         IF COALESCE (vbProdOptPatternId, 0) = 0
         THEN
             -- Создание
             vbProdOptPatternId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdOptPattern (ioId              := 0
                                                                                            , inCode            := 0
                                                                                            , inName            := vbProdOptPatternName
                                                                                            , inComment         := ''
                                                                                            , inSession         := inSession
                                                                                             ) AS tmp);
         END IF;

         vbProdOptionsId:= 0;
         -- Поиск - Options
         vbProdOptionsId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inOptionName7 AND Object.DescId = zc_Object_ProdOptions());
         IF COALESCE (vbProdOptionsId, 0) = 0
         THEN
             -- Создание
             vbProdOptionsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdOptions (ioId      := 0
                                                                                      , inCode    := 0
                                                                                      , inName    := inOptionName7
                                                                                      , inLevel   := 7
                                                                                      , inComment := ''
                                                                                      , inSession := inSession
                                                                                       ) AS tmp);
         END IF;

         -- Поиск - Items
         vbProdOptItemsId:= (SELECT OL_Product.ObjectId
                             FROM ObjectLink AS OL_Product
                                  INNER JOIN Object AS Object_ProdOptItems
                                                    ON Object_ProdOptItems.Id       = OL_Product.ObjectId
                                                   AND Object_ProdOptItems.isErased = FALSE
                                  INNER JOIN ObjectLink AS OL_ProdOptPattern
                                                        ON OL_ProdOptPattern.ObjectId      = OL_Product.ObjectId
                                                       AND OL_ProdOptPattern.DescId        = zc_ObjectLink_ProdOptItems_ProdOptPattern()
                                                       AND OL_ProdOptPattern.ChildObjectId = vbProdOptPatternId
                             WHERE OL_Product.ChildObjectId = vbProductId
                               AND OL_Product.DescId        = zc_ObjectLink_ProdOptItems_Product()
                            );
         IF COALESCE (vbProdOptItemsId, 0) = 0
         THEN
             -- Создание
             vbProdOptItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdOptItems (ioId              := 0
                                                                                        , inCode            := 7
                                                                                        , inProductId       := vbProductId
                                                                                        , inProdOptionsId   := vbProdOptionsId
                                                                                        , inProdOptPatternId:= vbProdOptPatternId
                                                                                        , inPriceIn         := inOptionPrice7 * 0.75
                                                                                        , inPriceOut        := inOptionPrice7
                                                                                        , inPartNumber      := inOptionPartNumber7
                                                                                        , inComment         := ''
                                                                                        , inSession         := inSession
                                                                                         ) AS tmp);
         END IF;

     END IF;

     -- 9.8.  ProdOptItemsId
     inOptionName8:= TRIM (inOptionName8);
     IF inOptionName8 <> ''
     THEN
         vbProdOptPatternId:= 0;
         vbProdOptPatternName:= 'Option 8';
         -- Поиск - ProdOptPattern
         vbProdOptPatternId:= (SELECT Object_ProdOptPattern.Id
                                 FROM Object AS Object_ProdOptPattern
                                 WHERE Object_ProdOptPattern.DescId    = zc_Object_ProdOptPattern()
                                   AND Object_ProdOptPattern.ValueData ILIKE vbProdOptPatternName
                                );
         IF COALESCE (vbProdOptPatternId, 0) = 0
         THEN
             -- Создание
             vbProdOptPatternId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdOptPattern (ioId              := 0
                                                                                            , inCode            := 0
                                                                                            , inName            := vbProdOptPatternName
                                                                                            , inComment         := ''
                                                                                            , inSession         := inSession
                                                                                             ) AS tmp);
         END IF;

         vbProdOptionsId:= 0;
         -- Поиск - Options
         vbProdOptionsId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inOptionName8 AND Object.DescId = zc_Object_ProdOptions());
         IF COALESCE (vbProdOptionsId, 0) = 0
         THEN
             -- Создание
             vbProdOptionsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdOptions (ioId      := 0
                                                                                      , inCode    := 0
                                                                                      , inName    := inOptionName8
                                                                                      , inLevel   := 8
                                                                                      , inComment := ''
                                                                                      , inSession := inSession
                                                                                       ) AS tmp);
         END IF;

         -- Поиск - Items
         vbProdOptItemsId:= (SELECT OL_Product.ObjectId
                             FROM ObjectLink AS OL_Product
                                  INNER JOIN Object AS Object_ProdOptItems
                                                    ON Object_ProdOptItems.Id       = OL_Product.ObjectId
                                                   AND Object_ProdOptItems.isErased = FALSE
                                  INNER JOIN ObjectLink AS OL_ProdOptPattern
                                                        ON OL_ProdOptPattern.ObjectId      = OL_Product.ObjectId
                                                       AND OL_ProdOptPattern.DescId        = zc_ObjectLink_ProdOptItems_ProdOptPattern()
                                                       AND OL_ProdOptPattern.ChildObjectId = vbProdOptPatternId
                             WHERE OL_Product.ChildObjectId = vbProductId
                               AND OL_Product.DescId        = zc_ObjectLink_ProdOptItems_Product()
                            );
         IF COALESCE (vbProdOptItemsId, 0) = 0
         THEN
             -- Создание
             vbProdOptItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdOptItems (ioId              := 0
                                                                                        , inCode            := 8
                                                                                        , inProductId       := vbProductId
                                                                                        , inProdOptionsId   := vbProdOptionsId
                                                                                        , inProdOptPatternId:= vbProdOptPatternId
                                                                                        , inPriceIn         := inOptionPrice8 * 0.75
                                                                                        , inPriceOut        := inOptionPrice8
                                                                                        , inPartNumber      := inOptionPartNumber8
                                                                                        , inComment         := ''
                                                                                        , inSession         := inSession
                                                                                         ) AS tmp);
         END IF;

     END IF;


   --RAISE EXCEPTION 'Ошибка.End OK';


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 29.09.22                                                       *
 11.10.20         *
*/

-- update Object set isErased = true where DescId in (zc_Object_ProdColorItems() , zc_Object_ProdOptItems(), zc_Object_Product())
/*
select * from gpSelect_Object_ImportSettingsItems(inImportSettingsId := 1321 ,  inSession := '3');
select * from gpSelect_Object_ImportSettings( inSession := '3');

*/