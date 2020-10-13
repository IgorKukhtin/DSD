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

    IN inDateStart           TDateTime ,    -- ������ ������������
    IN inDateBegin           TDateTime ,    -- ���� � ������������
    IN inDateSale            TDateTime ,    -- ���� �������
    IN inArticle             TVarChar  ,    -- ������� - �����

    IN inBrandName           TVarChar  ,
    IN inProdModelName       TVarChar  ,
    IN inCIN                 TVarChar  ,    -- � CIN - �����
    IN inProdEngineName      TVarChar  ,    -- �����
    IN inPower               TFloat    ,    -- ��������
    IN inEngineNum           TVarChar  ,    -- �  - ������
    IN inHours               TFloat    ,    -- ������������ �����
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

    IN inSession             TVarChar       -- ������ ������������
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

   DECLARE vbProdOptionsId Integer;
   DECLARE vbProdOptItemsId Integer;

BEGIN
     -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Product());
     vbUserId:= lpGetUserBySession (inSession);

     -- 1.1. �������� �����
     inBrandName:= TRIM (inBrandName);
     -- ��������
     IF COALESCE (TRIM (inBrandName), '') = '' THEN
        RAISE EXCEPTION '������.������ ���� �������� BrandName.';
     END IF;

     -- �����
     vbBrandId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inBrandName AND Object.DescId = zc_Object_Brand());
     --
     IF COALESCE (vbBrandId, 0) = 0
     THEN
         -- ��������
         vbBrandId := (SELECT tmp.ioId FROM gpInsertUpdate_Object_Brand (ioId      := 0
                                                                       , ioCode    := 0
                                                                       , inName    := inBrandName
                                                                       , inComment := ''
                                                                       , inSession := inSession
                                                                        ) AS tmp);
     END IF;


     -- 1.2. ������ - �����
     inProdModelName:= TRIM (inProdModelName);
     -- ��������
     IF COALESCE (TRIM (inProdModelName), '') = '' THEN
        RAISE EXCEPTION '������.������ ���� �������� Model.';
     END IF;

     -- �����
     vbProdModelId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inProdModelName AND Object.DescId = zc_Object_ProdModel());
     --
     IF COALESCE (vbProdModelId, 0) = 0
     THEN
         -- ��������
         vbProdModelId := (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdModel (ioId      := 0
                                                                               , inCode    := 0
                                                                               , inName    := inProdModelName
                                                                               , inLength  := inLength
                                                                               , inBeam    := inBeam
                                                                               , inHeight  := inHeight
                                                                               , inWeight  := inWeight
                                                                               , inFuel    := inFuel
                                                                               , inSpeed   := inSpeed
                                                                               , inSeating := inSeating
                                                                               , inComment := ''
                                                                               , inSession := inSession
                                                                                ) AS tmp);
     END IF;


     -- 1.3.  ����� - �����
     inProdEngineName:= TRIM (inProdEngineName);
     -- ��������
     IF COALESCE (TRIM (inProdEngineName), '') = '' THEN
        RAISE EXCEPTION '������.������ ���� �������� Engine.';
     END IF;

     -- �����
     vbProdEngineId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inProdEngineName AND Object.DescId = zc_Object_ProdEngine());
     --
     IF COALESCE (vbProdEngineId, 0) = 0
     THEN
         -- ��������
         vbProdEngineId := (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdEngine (ioId      := 0
                                                                                 , inCode    := 0
                                                                                 , inName    := inProdEngineName
                                                                                 , inPower   := inPower
                                                                                 , inComment := ''
                                                                                 , inSession := inSession
                                                                                  ) AS tmp);
     END IF;


     -- 2. ������� - �����
     inArticle:= TRIM (inArticle);
     -- ��������
     IF COALESCE (TRIM (inArticle), '') = '' THEN
        RAISE EXCEPTION '������.������ ���� �������� ������� - �����.';
     END IF;
     -- ��������
     IF COALESCE (TRIM (inCIN), '') = '' THEN
        RAISE EXCEPTION '������.������ ���� �������� CIN.';
     END IF;
     -- ��������
     IF COALESCE (TRIM (inEngineNum), '') = '' THEN
        RAISE EXCEPTION '������.������ ���� �������� EngineNum.';
     END IF;

     -- �����
     vbProductId:= (SELECT Object.Id FROM ObjectString AS OS_Article JOIN Object ON Object.Id = OS_Article.ObjectId AND Object.DescId = zc_Object_Product() WHERE OS_Article.DescId = zc_ObjectString_Article() AND OS_Article.ValueData ILIKE inArticle);
     --
     IF COALESCE (vbProductId, 0) = 0 OR 1=1
     THEN
    RAISE EXCEPTION '������.<%>', SUBSTRING (inBrandName, 1, 3) || ' ' || inProdModelName || ' ' || inProdEngineName || ' ' || inCIN;

         -- ��������
         vbProductId := (SELECT tmp.ioId FROM gpInsertUpdate_Object_Product (ioId            := vbProductId
                                                                           , inCode          := CASE WHEN vbProductId > 0 THEN (SELECT Object.ObjectCode FROM Object WHERE Object.Id = vbProductId) ELSE NEXTVAL ('Object_Product_seq') END :: Integer
                                                                           , inName          := SUBSTRING (inBrandName, 1, 2) || ' ' || inProdModelName || ' ' || inProdEngineName || ' ' || inCIN
                                                                           , inBrandId       := vbBrandId
                                                                           , inModelId       := vbProdModelId
                                                                           , inEngineId      := vbProdEngineId
                                                                           , inHours         := inHours
                                                                           , inDateStart     := inDateStart
                                                                           , inDateBegin     := inDateBegin
                                                                           , inDateSale      := inDateSale
                                                                           , inArticle       := inArticle
                                                                           , inCIN           := inCIN
                                                                           , inEngineNum     := inEngineNum
                                                                           , inComment       := ''
                                                                           , inSession       := inSession
                                                                            ) AS tmp);
     END IF;


     -- 3.1. Hypalon
     vbProdColorGroupName1:= 'Hypalon';
     -- �����
     vbProdColorGroupId1:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE vbProdColorGroupName1 AND Object.DescId = zc_Object_ProdColorGroup());
     IF COALESCE (vbProdColorGroupId1, 0) = 0
     THEN
         -- ��������
         vbProdColorGroupId1:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorGroup (ioId      := 0
                                                                                         , ioCode    := 0
                                                                                         , inName    := vbProdColorGroupName1
                                                                                         , inComment := ''
                                                                                         , inSession := inSession
                                                                                          ) AS tmp);
     END IF;

     -- 3.2. ������ + ������ + ������� �������� ����������
     vbProdColorGroupName2:= 'Fiberglass';
     -- �����
     vbProdColorGroupId2:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE vbProdColorGroupName2 AND Object.DescId = zc_Object_ProdColorGroup());
     IF COALESCE (vbProdColorGroupId2, 0) = 0
     THEN
         -- ��������
         vbProdColorGroupId2:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorGroup (ioId      := 0
                                                                                         , ioCode    := 0
                                                                                         , inName    := vbProdColorGroupName2
                                                                                         , inComment := ''
                                                                                         , inSession := inSession
                                                                                          ) AS tmp);
     END IF;

     -- 3.3. ������
     vbProdColorGroupName3:= 'Upholstery';
     -- �����
     vbProdColorGroupId3:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE vbProdColorGroupName3 AND Object.DescId = zc_Object_ProdColorGroup());
     IF COALESCE (vbProdColorGroupId3, 0) = 0
     THEN
         -- ��������
         vbProdColorGroupId3:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorGroup (ioId      := 0
                                                                                         , ioCode    := 0
                                                                                         , inName    := vbProdColorGroupName3
                                                                                         , inComment := ''
                                                                                         , inSession := inSession
                                                                                          ) AS tmp);
     END IF;

     -- 3.4. ���� ������� + ��� �������
     vbProdColorGroupName4:= 'Stitching';
     -- �����
     vbProdColorGroupId4:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE vbProdColorGroupName4 AND Object.DescId = zc_Object_ProdColorGroup());
     IF COALESCE (vbProdColorGroupId4, 0) = 0
     THEN
         -- ��������
         vbProdColorGroupId4:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorGroup (ioId      := 0
                                                                                         , ioCode    := 0
                                                                                         , inName    := vbProdColorGroupName4
                                                                                         , inComment := ''
                                                                                         , inSession := inSession
                                                                                          ) AS tmp);
     END IF;

     -- 3.5. ����
     vbProdColorGroupName5:= 'Color';
     -- �����
     vbProdColorGroupId5:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE vbProdColorGroupName5 AND Object.DescId = zc_Object_ProdColorGroup());
     IF COALESCE (vbProdColorGroupId5, 0) = 0
     THEN
         -- ��������
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
         vbColorId:= 0;
         -- ����� - Color
         vbColorId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inHypalon1 AND Object.DescId = zc_Object_ProdColor());
         IF COALESCE (vbColorId, 0) = 0
         THEN
             -- ��������
             vbColorId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColor (ioId      := 0
                                                                              , ioCode    := 0
                                                                              , inName    := inHypalon1
                                                                              , inComment := ''
                                                                              , inSession := inSession
                                                                               ) AS tmp);
         END IF;

         -- ����� - Items
         vbProdColorItemsId:= (SELECT OL_Product.ObjectId
                               FROM ObjectLink AS OL_Product
                                    INNER JOIN ObjectLink AS OL_ProdColorGroup
                                                          ON OL_ProdColorGroup.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorItems_ProdColorGroup()
                                                         AND OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId1
                                    INNER JOIN Object AS Object_ProdColorItems
                                                      ON Object_ProdColorItems.Id         = OL_Product.ObjectId
                                                     AND Object_ProdColorItems.ObjectCode = 1
                                                     AND Object_ProdColorItems.isErased   = FALSE
                               WHERE OL_Product.ChildObjectId = vbProductId
                                 AND OL_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                              );
         IF COALESCE (vbProdColorItemsId, 0) = 0
         THEN
             -- ��������
             vbProdColorItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorItems (ioId              := 0
                                                                                            , inCode            := 1
                                                                                            , inName            := '�1'
                                                                                            , inProductId       := vbProductId
                                                                                            , inProdColorGroupId:= vbProdColorGroupId1
                                                                                            , inProdColorId     := vbColorId
                                                                                            , inComment         := ''
                                                                                            , inSession         := inSession
                                                                                             ) AS tmp);
         END IF;

     END IF;


     -- 4.2.  ProdColorItemsId - Hypalon
     inHypalon2:= TRIM (inHypalon2);
     IF inHypalon2 <> ''
     THEN
         vbColorId:= 0;
         -- ����� - Color
         vbColorId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inHypalon2 AND Object.DescId = zc_Object_ProdColor());
         IF COALESCE (vbColorId, 0) = 0
         THEN
             -- ��������
             vbColorId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColor (ioId      := 0
                                                                              , ioCode    := 0
                                                                              , inName    := inHypalon2
                                                                              , inComment := ''
                                                                              , inSession := inSession
                                                                               ) AS tmp);
         END IF;

         -- ����� - Items
         vbProdColorItemsId:= (SELECT OL_Product.ObjectId
                               FROM ObjectLink AS OL_Product
                                    INNER JOIN ObjectLink AS OL_ProdColorGroup
                                                          ON OL_ProdColorGroup.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorItems_ProdColorGroup()
                                                         AND OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId1
                                    INNER JOIN Object AS Object_ProdColorItems
                                                      ON Object_ProdColorItems.Id         = OL_Product.ObjectId
                                                     AND Object_ProdColorItems.ObjectCode = 2
                                                     AND Object_ProdColorItems.isErased   = FALSE
                               WHERE OL_Product.ChildObjectId = vbProductId
                                 AND OL_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                              );
         IF COALESCE (vbProdColorItemsId, 0) = 0
         THEN
             -- ��������
             vbProdColorItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorItems (ioId              := 0
                                                                                            , inCode            := 2
                                                                                            , inName            := '�2'
                                                                                            , inProductId       := vbProductId
                                                                                            , inProdColorGroupId:= vbProdColorGroupId1
                                                                                            , inProdColorId     := vbColorId
                                                                                            , inComment         := ''
                                                                                            , inSession         := inSession
                                                                                             ) AS tmp);
         END IF;

     END IF;


     -- 5.1.  ProdColorItemsId - Fiberglass - Deck - SteeringConsole
     inFiberglassHull:= TRIM (inFiberglassHull);
     IF inFiberglassHull <> ''
     THEN
         vbColorId:= 0;
         -- ����� - Color
         vbColorId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inFiberglassHull AND Object.DescId = zc_Object_ProdColor());
         IF COALESCE (vbColorId, 0) = 0
         THEN
             -- ��������
             vbColorId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColor (ioId      := 0
                                                                              , ioCode    := 0
                                                                              , inName    := inFiberglassHull
                                                                              , inComment := ''
                                                                              , inSession := inSession
                                                                               ) AS tmp);
         END IF;

         -- ����� - Items
         vbProdColorItemsId:= (SELECT OL_Product.ObjectId
                               FROM ObjectLink AS OL_Product
                                    INNER JOIN ObjectLink AS OL_ProdColorGroup
                                                          ON OL_ProdColorGroup.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorItems_ProdColorGroup()
                                                         AND OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId2
                                    INNER JOIN Object AS Object_ProdColorItems
                                                      ON Object_ProdColorItems.Id         = OL_Product.ObjectId
                                                     AND Object_ProdColorItems.ObjectCode = 1
                                                     AND Object_ProdColorItems.isErased   = FALSE
                               WHERE OL_Product.ChildObjectId = vbProductId
                                 AND OL_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                              );
         IF COALESCE (vbProdColorItemsId, 0) = 0
         THEN
             -- ��������
             vbProdColorItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorItems (ioId              := 0
                                                                                            , inCode            := 1
                                                                                            , inName            := 'Hull'
                                                                                            , inProductId       := vbProductId
                                                                                            , inProdColorGroupId:= vbProdColorGroupId2
                                                                                            , inProdColorId     := vbColorId
                                                                                            , inComment         := ''
                                                                                            , inSession         := inSession
                                                                                             ) AS tmp);
         END IF;

     END IF;

     -- 5.2.  ProdColorItemsId - Fiberglass - Deck - SteeringConsole
     inFiberglassDeck:= TRIM (inFiberglassDeck);
     IF inFiberglassDeck <> ''
     THEN
         vbColorId:= 0;
         -- ����� - Color
         vbColorId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inFiberglassDeck AND Object.DescId = zc_Object_ProdColor());
         IF COALESCE (vbColorId, 0) = 0
         THEN
             -- ��������
             vbColorId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColor (ioId      := 0
                                                                              , ioCode    := 0
                                                                              , inName    := inFiberglassDeck
                                                                              , inComment := ''
                                                                              , inSession := inSession
                                                                               ) AS tmp);
         END IF;

         -- ����� - Items
         vbProdColorItemsId:= (SELECT OL_Product.ObjectId
                               FROM ObjectLink AS OL_Product
                                    INNER JOIN ObjectLink AS OL_ProdColorGroup
                                                          ON OL_ProdColorGroup.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorItems_ProdColorGroup()
                                                         AND OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId2
                                    INNER JOIN Object AS Object_ProdColorItems
                                                      ON Object_ProdColorItems.Id         = OL_Product.ObjectId
                                                     AND Object_ProdColorItems.ObjectCode = 2
                                                     AND Object_ProdColorItems.isErased   = FALSE
                               WHERE OL_Product.ChildObjectId = vbProductId
                                 AND OL_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                              );
         IF COALESCE (vbProdColorItemsId, 0) = 0
         THEN
             -- ��������
             vbProdColorItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorItems (ioId              := 0
                                                                                            , inCode            := 2
                                                                                            , inName            := 'Deck'
                                                                                            , inProductId       := vbProductId
                                                                                            , inProdColorGroupId:= vbProdColorGroupId2
                                                                                            , inProdColorId     := vbColorId
                                                                                            , inComment         := ''
                                                                                            , inSession         := inSession
                                                                                             ) AS tmp);
         END IF;

     END IF;


     -- 5.3.  ProdColorItemsId - Fiberglass - Deck - SteeringConsole
     inFiberglassSteeringConsole:= TRIM (inFiberglassSteeringConsole);
     IF inFiberglassSteeringConsole <> ''
     THEN
         vbColorId:= 0;
         -- ����� - Color
         vbColorId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inFiberglassSteeringConsole AND Object.DescId = zc_Object_ProdColor());
         IF COALESCE (vbColorId, 0) = 0
         THEN
             -- ��������
             vbColorId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColor (ioId      := 0
                                                                              , ioCode    := 0
                                                                              , inName    := inFiberglassSteeringConsole
                                                                              , inComment := ''
                                                                              , inSession := inSession
                                                                               ) AS tmp);
         END IF;

         -- ����� - Items
         vbProdColorItemsId:= (SELECT OL_Product.ObjectId
                               FROM ObjectLink AS OL_Product
                                    INNER JOIN ObjectLink AS OL_ProdColorGroup
                                                          ON OL_ProdColorGroup.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorItems_ProdColorGroup()
                                                         AND OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId2
                                    INNER JOIN Object AS Object_ProdColorItems
                                                      ON Object_ProdColorItems.Id         = OL_Product.ObjectId
                                                     AND Object_ProdColorItems.ObjectCode = 3
                                                     AND Object_ProdColorItems.isErased   = FALSE
                               WHERE OL_Product.ChildObjectId = vbProductId
                                 AND OL_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                              );
         IF COALESCE (vbProdColorItemsId, 0) = 0
         THEN
             -- ��������
             vbProdColorItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorItems (ioId              := 0
                                                                                            , inCode            := 3
                                                                                            , inName            := 'SteeringConsole'
                                                                                            , inProductId       := vbProductId
                                                                                            , inProdColorGroupId:= vbProdColorGroupId2
                                                                                            , inProdColorId     := vbColorId
                                                                                            , inComment         := ''
                                                                                            , inSession         := inSession
                                                                                             ) AS tmp);
         END IF;

     END IF;


     -- 6.1.  ProdColorItemsId - Upholstery
     inUpholstery1:= TRIM (inUpholstery1);
     IF inUpholstery1 <> ''
     THEN
         vbColorId:= 0;
         -- ����� - Color
         vbColorId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inUpholstery1 AND Object.DescId = zc_Object_ProdColor());
         IF COALESCE (vbColorId, 0) = 0
         THEN
             -- ��������
             vbColorId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColor (ioId      := 0
                                                                              , ioCode    := 0
                                                                              , inName    := inUpholstery1
                                                                              , inComment := ''
                                                                              , inSession := inSession
                                                                               ) AS tmp);
         END IF;

         -- ����� - Items
         vbProdColorItemsId:= (SELECT OL_Product.ObjectId
                               FROM ObjectLink AS OL_Product
                                    INNER JOIN ObjectLink AS OL_ProdColorGroup
                                                          ON OL_ProdColorGroup.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorItems_ProdColorGroup()
                                                         AND OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId3
                                    INNER JOIN Object AS Object_ProdColorItems
                                                      ON Object_ProdColorItems.Id         = OL_Product.ObjectId
                                                     AND Object_ProdColorItems.ObjectCode = 1
                                                     AND Object_ProdColorItems.isErased   = FALSE
                               WHERE OL_Product.ChildObjectId = vbProductId
                                 AND OL_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                              );
         IF COALESCE (vbProdColorItemsId, 0) = 0
         THEN
             -- ��������
             vbProdColorItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorItems (ioId              := 0
                                                                                            , inCode            := 1
                                                                                            , inName            := '1'
                                                                                            , inProductId       := vbProductId
                                                                                            , inProdColorGroupId:= vbProdColorGroupId3
                                                                                            , inProdColorId     := vbColorId
                                                                                            , inComment         := ''
                                                                                            , inSession         := inSession
                                                                                             ) AS tmp);
         END IF;

     END IF;


     -- 6.2.  ProdColorItemsId - Upholstery
     inUpholstery2:= TRIM (inUpholstery2);
     IF inUpholstery2 <> ''
     THEN
         vbColorId:= 0;
         -- ����� - Color
         vbColorId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inUpholstery2 AND Object.DescId = zc_Object_ProdColor());
         IF COALESCE (vbColorId, 0) = 0
         THEN
             -- ��������
             vbColorId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColor (ioId      := 0
                                                                              , ioCode    := 0
                                                                              , inName    := inUpholstery2
                                                                              , inComment := ''
                                                                              , inSession := inSession
                                                                               ) AS tmp);
         END IF;

         -- ����� - Items
         vbProdColorItemsId:= (SELECT OL_Product.ObjectId
                               FROM ObjectLink AS OL_Product
                                    INNER JOIN ObjectLink AS OL_ProdColorGroup
                                                          ON OL_ProdColorGroup.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorItems_ProdColorGroup()
                                                         AND OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId3
                                    INNER JOIN Object AS Object_ProdColorItems
                                                      ON Object_ProdColorItems.Id         = OL_Product.ObjectId
                                                     AND Object_ProdColorItems.ObjectCode = 2
                                                     AND Object_ProdColorItems.isErased   = FALSE
                               WHERE OL_Product.ChildObjectId = vbProductId
                                 AND OL_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                              );
         IF COALESCE (vbProdColorItemsId, 0) = 0
         THEN
             -- ��������
             vbProdColorItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorItems (ioId              := 0
                                                                                            , inCode            := 2
                                                                                            , inName            := '2'
                                                                                            , inProductId       := vbProductId
                                                                                            , inProdColorGroupId:= vbProdColorGroupId3
                                                                                            , inProdColorId     := vbColorId
                                                                                            , inComment         := ''
                                                                                            , inSession         := inSession
                                                                                             ) AS tmp);
         END IF;

     END IF;

     -- 6.3.  ProdColorItemsId - Upholstery
     inUpholstery3:= TRIM (inUpholstery3);
     IF inUpholstery3 <> ''
     THEN
         vbColorId:= 0;
         -- ����� - Color
         vbColorId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inUpholstery3 AND Object.DescId = zc_Object_ProdColor());
         IF COALESCE (vbColorId, 0) = 0
         THEN
             -- ��������
             vbColorId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColor (ioId      := 0
                                                                              , ioCode    := 0
                                                                              , inName    := inUpholstery3
                                                                              , inComment := ''
                                                                              , inSession := inSession
                                                                               ) AS tmp);
         END IF;

         -- ����� - Items
         vbProdColorItemsId:= (SELECT OL_Product.ObjectId
                               FROM ObjectLink AS OL_Product
                                    INNER JOIN ObjectLink AS OL_ProdColorGroup
                                                          ON OL_ProdColorGroup.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorItems_ProdColorGroup()
                                                         AND OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId3
                                    INNER JOIN Object AS Object_ProdColorItems
                                                      ON Object_ProdColorItems.Id         = OL_Product.ObjectId
                                                     AND Object_ProdColorItems.ObjectCode = 3
                                                     AND Object_ProdColorItems.isErased   = FALSE
                               WHERE OL_Product.ChildObjectId = vbProductId
                                 AND OL_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                              );
         IF COALESCE (vbProdColorItemsId, 0) = 0
         THEN
             -- ��������
             vbProdColorItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorItems (ioId              := 0
                                                                                            , inCode            := 3
                                                                                            , inName            := '3'
                                                                                            , inProductId       := vbProductId
                                                                                            , inProdColorGroupId:= vbProdColorGroupId3
                                                                                            , inProdColorId     := vbColorId
                                                                                            , inComment         := ''
                                                                                            , inSession         := inSession
                                                                                             ) AS tmp);
         END IF;

     END IF;

     -- 6.4.  ProdColorItemsId - Upholstery
     inUpholstery4:= TRIM (inUpholstery4);
     IF inUpholstery4 <> ''
     THEN
         vbColorId:= 0;
         -- ����� - Color
         vbColorId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inUpholstery4 AND Object.DescId = zc_Object_ProdColor());
         IF COALESCE (vbColorId, 0) = 0
         THEN
             -- ��������
             vbColorId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColor (ioId      := 0
                                                                              , ioCode    := 0
                                                                              , inName    := inUpholstery4
                                                                              , inComment := ''
                                                                              , inSession := inSession
                                                                               ) AS tmp);
         END IF;

         -- ����� - Items
         vbProdColorItemsId:= (SELECT OL_Product.ObjectId
                               FROM ObjectLink AS OL_Product
                                    INNER JOIN ObjectLink AS OL_ProdColorGroup
                                                          ON OL_ProdColorGroup.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorItems_ProdColorGroup()
                                                         AND OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId3
                                    INNER JOIN Object AS Object_ProdColorItems
                                                      ON Object_ProdColorItems.Id         = OL_Product.ObjectId
                                                     AND Object_ProdColorItems.ObjectCode = 4
                                                     AND Object_ProdColorItems.isErased   = FALSE
                               WHERE OL_Product.ChildObjectId = vbProductId
                                 AND OL_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                              );
         IF COALESCE (vbProdColorItemsId, 0) = 0
         THEN
             -- ��������
             vbProdColorItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorItems (ioId              := 0
                                                                                            , inCode            := 4
                                                                                            , inName            := '4'
                                                                                            , inProductId       := vbProductId
                                                                                            , inProdColorGroupId:= vbProdColorGroupId3
                                                                                            , inProdColorId     := vbColorId
                                                                                            , inComment         := ''
                                                                                            , inSession         := inSession
                                                                                             ) AS tmp);
         END IF;

     END IF;


     -- 7.1.  ProdColorItemsId - StitchingColor + StitchingType
     inStitchingColor:= TRIM (inStitchingColor);
     IF inStitchingColor <> ''
     THEN
         vbColorId:= 0;
         -- ����� - Color
         vbColorId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inStitchingColor AND Object.DescId = zc_Object_ProdColor());
         IF COALESCE (vbColorId, 0) = 0
         THEN
             -- ��������
             vbColorId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColor (ioId      := 0
                                                                              , ioCode    := 0
                                                                              , inName    := inStitchingColor
                                                                              , inComment := ''
                                                                              , inSession := inSession
                                                                               ) AS tmp);
         END IF;

         -- ����� - Items
         vbProdColorItemsId:= (SELECT OL_Product.ObjectId
                               FROM ObjectLink AS OL_Product
                                    INNER JOIN ObjectLink AS OL_ProdColorGroup
                                                          ON OL_ProdColorGroup.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorItems_ProdColorGroup()
                                                         AND OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId4
                                    INNER JOIN Object AS Object_ProdColorItems
                                                      ON Object_ProdColorItems.Id         = OL_Product.ObjectId
                                                     AND Object_ProdColorItems.ObjectCode = 1
                                                     AND Object_ProdColorItems.isErased   = FALSE
                               WHERE OL_Product.ChildObjectId = vbProductId
                                 AND OL_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                              );
         IF COALESCE (vbProdColorItemsId, 0) = 0
         THEN
             -- ��������
             vbProdColorItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorItems (ioId              := 0
                                                                                            , inCode            := 1
                                                                                            , inName            := 'Color'
                                                                                            , inProductId       := vbProductId
                                                                                            , inProdColorGroupId:= vbProdColorGroupId4
                                                                                            , inProdColorId     := vbColorId
                                                                                            , inComment         := ''
                                                                                            , inSession         := inSession
                                                                                             ) AS tmp);
         END IF;

     END IF;

     -- 7.2.  ProdColorItemsId - StitchingColor + StitchingType
     inStitchingType:= TRIM (inStitchingType);
     IF inStitchingType <> ''
     THEN
         vbColorId:= 0;
         -- ����� - Color
         vbColorId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inStitchingType AND Object.DescId = zc_Object_ProdColor());
         IF COALESCE (vbColorId, 0) = 0
         THEN
             -- ��������
             vbColorId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColor (ioId      := 0
                                                                              , ioCode    := 0
                                                                              , inName    := inStitchingType
                                                                              , inComment := ''
                                                                              , inSession := inSession
                                                                               ) AS tmp);
         END IF;

         -- ����� - Items
         vbProdColorItemsId:= (SELECT OL_Product.ObjectId
                               FROM ObjectLink AS OL_Product
                                    INNER JOIN ObjectLink AS OL_ProdColorGroup
                                                          ON OL_ProdColorGroup.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorItems_ProdColorGroup()
                                                         AND OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId4
                                    INNER JOIN Object AS Object_ProdColorItems
                                                      ON Object_ProdColorItems.Id         = OL_Product.ObjectId
                                                     AND Object_ProdColorItems.ObjectCode = 2
                                                     AND Object_ProdColorItems.isErased   = FALSE
                               WHERE OL_Product.ChildObjectId = vbProductId
                                 AND OL_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                              );
         IF COALESCE (vbProdColorItemsId, 0) = 0
         THEN
             -- ��������
             vbProdColorItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorItems (ioId              := 0
                                                                                            , inCode            := 2
                                                                                            , inName            := 'Type'
                                                                                            , inProductId       := vbProductId
                                                                                            , inProdColorGroupId:= vbProdColorGroupId4
                                                                                            , inProdColorId     := vbColorId
                                                                                            , inComment         := ''
                                                                                            , inSession         := inSession
                                                                                             ) AS tmp);
         END IF;

     END IF;



     -- 8.1.  ProdColorItemsId - Color
     inColor1:= TRIM (inColor1);
     IF inColor1 <> ''
     THEN
         vbColorId:= 0;
         -- ����� - Color
         vbColorId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inColor1 AND Object.DescId = zc_Object_ProdColor());
         IF COALESCE (vbColorId, 0) = 0
         THEN
             -- ��������
             vbColorId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColor (ioId      := 0
                                                                              , ioCode    := 0
                                                                              , inName    := inColor1
                                                                              , inComment := ''
                                                                              , inSession := inSession
                                                                               ) AS tmp);
         END IF;

         -- ����� - Items
         vbProdColorItemsId:= (SELECT OL_Product.ObjectId
                               FROM ObjectLink AS OL_Product
                                    INNER JOIN ObjectLink AS OL_ProdColorGroup
                                                          ON OL_ProdColorGroup.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorItems_ProdColorGroup()
                                                         AND OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId5
                                    INNER JOIN Object AS Object_ProdColorItems
                                                      ON Object_ProdColorItems.Id         = OL_Product.ObjectId
                                                     AND Object_ProdColorItems.ObjectCode = 1
                                                     AND Object_ProdColorItems.isErased   = FALSE
                               WHERE OL_Product.ChildObjectId = vbProductId
                                 AND OL_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                              );
         IF COALESCE (vbProdColorItemsId, 0) = 0
         THEN
             -- ��������
             vbProdColorItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorItems (ioId              := 0
                                                                                            , inCode            := 1
                                                                                            , inName            := '1'
                                                                                            , inProductId       := vbProductId
                                                                                            , inProdColorGroupId:= vbProdColorGroupId5
                                                                                            , inProdColorId     := vbColorId
                                                                                            , inComment         := ''
                                                                                            , inSession         := inSession
                                                                                             ) AS tmp);
         END IF;

     END IF;


     -- 8.2.  ProdColorItemsId - Color
     inColor2:= TRIM (inColor2);
     IF inColor2 <> ''
     THEN
         vbColorId:= 0;
         -- ����� - Color
         vbColorId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inColor2 AND Object.DescId = zc_Object_ProdColor());
         IF COALESCE (vbColorId, 0) = 0
         THEN
             -- ��������
             vbColorId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColor (ioId      := 0
                                                                              , ioCode    := 0
                                                                              , inName    := inColor2
                                                                              , inComment := ''
                                                                              , inSession := inSession
                                                                               ) AS tmp);
         END IF;

         -- ����� - Items
         vbProdColorItemsId:= (SELECT OL_Product.ObjectId
                               FROM ObjectLink AS OL_Product
                                    INNER JOIN ObjectLink AS OL_ProdColorGroup
                                                          ON OL_ProdColorGroup.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorItems_ProdColorGroup()
                                                         AND OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId5
                                    INNER JOIN Object AS Object_ProdColorItems
                                                      ON Object_ProdColorItems.Id         = OL_Product.ObjectId
                                                     AND Object_ProdColorItems.ObjectCode = 2
                                                     AND Object_ProdColorItems.isErased   = FALSE
                               WHERE OL_Product.ChildObjectId = vbProductId
                                 AND OL_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                              );
         IF COALESCE (vbProdColorItemsId, 0) = 0
         THEN
             -- ��������
             vbProdColorItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorItems (ioId              := 0
                                                                                            , inCode            := 2
                                                                                            , inName            := '2'
                                                                                            , inProductId       := vbProductId
                                                                                            , inProdColorGroupId:= vbProdColorGroupId5
                                                                                            , inProdColorId     := vbColorId
                                                                                            , inComment         := ''
                                                                                            , inSession         := inSession
                                                                                             ) AS tmp);
         END IF;

     END IF;

     -- 8.3.  ProdColorItemsId - Color
     inColor3:= TRIM (inColor3);
     IF inColor3 <> ''
     THEN
         vbColorId:= 0;
         -- ����� - Color
         vbColorId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inColor3 AND Object.DescId = zc_Object_ProdColor());
         IF COALESCE (vbColorId, 0) = 0
         THEN
             -- ��������
             vbColorId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColor (ioId      := 0
                                                                              , ioCode    := 0
                                                                              , inName    := inColor3
                                                                              , inComment := ''
                                                                              , inSession := inSession
                                                                               ) AS tmp);
         END IF;

         -- ����� - Items
         vbProdColorItemsId:= (SELECT OL_Product.ObjectId
                               FROM ObjectLink AS OL_Product
                                    INNER JOIN ObjectLink AS OL_ProdColorGroup
                                                          ON OL_ProdColorGroup.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorItems_ProdColorGroup()
                                                         AND OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId5
                                    INNER JOIN Object AS Object_ProdColorItems
                                                      ON Object_ProdColorItems.Id         = OL_Product.ObjectId
                                                     AND Object_ProdColorItems.ObjectCode = 3
                                                     AND Object_ProdColorItems.isErased   = FALSE
                               WHERE OL_Product.ChildObjectId = vbProductId
                                 AND OL_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                              );
         IF COALESCE (vbProdColorItemsId, 0) = 0
         THEN
             -- ��������
             vbProdColorItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorItems (ioId              := 0
                                                                                            , inCode            := 3
                                                                                            , inName            := '3'
                                                                                            , inProductId       := vbProductId
                                                                                            , inProdColorGroupId:= vbProdColorGroupId5
                                                                                            , inProdColorId     := vbColorId
                                                                                            , inComment         := ''
                                                                                            , inSession         := inSession
                                                                                             ) AS tmp);
         END IF;

     END IF;

     -- 8.4.  ProdColorItemsId - Color
     inColor4:= TRIM (inColor4);
     IF inColor4 <> ''
     THEN
         vbColorId:= 0;
         -- ����� - Color
         vbColorId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inColor4 AND Object.DescId = zc_Object_ProdColor());
         IF COALESCE (vbColorId, 0) = 0
         THEN
             -- ��������
             vbColorId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColor (ioId      := 0
                                                                              , ioCode    := 0
                                                                              , inName    := inColor4
                                                                              , inComment := ''
                                                                              , inSession := inSession
                                                                               ) AS tmp);
         END IF;

         -- ����� - Items
         vbProdColorItemsId:= (SELECT OL_Product.ObjectId
                               FROM ObjectLink AS OL_Product
                                    INNER JOIN ObjectLink AS OL_ProdColorGroup
                                                          ON OL_ProdColorGroup.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorItems_ProdColorGroup()
                                                         AND OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId5
                                    INNER JOIN Object AS Object_ProdColorItems
                                                      ON Object_ProdColorItems.Id         = OL_Product.ObjectId
                                                     AND Object_ProdColorItems.ObjectCode = 4
                                                     AND Object_ProdColorItems.isErased   = FALSE
                               WHERE OL_Product.ChildObjectId = vbProductId
                                 AND OL_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                              );
         IF COALESCE (vbProdColorItemsId, 0) = 0
         THEN
             -- ��������
             vbProdColorItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorItems (ioId              := 0
                                                                                            , inCode            := 4
                                                                                            , inName            := '4'
                                                                                            , inProductId       := vbProductId
                                                                                            , inProdColorGroupId:= vbProdColorGroupId5
                                                                                            , inProdColorId     := vbColorId
                                                                                            , inComment         := ''
                                                                                            , inSession         := inSession
                                                                                             ) AS tmp);
         END IF;

     END IF;

     -- 8.5.  ProdColorItemsId - Color
     inColor5:= TRIM (inColor5);
     IF inColor5 <> ''
     THEN
         vbColorId:= 0;
         -- ����� - Color
         vbColorId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inColor5 AND Object.DescId = zc_Object_ProdColor());
         IF COALESCE (vbColorId, 0) = 0
         THEN
             -- ��������
             vbColorId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColor (ioId      := 0
                                                                              , ioCode    := 0
                                                                              , inName    := inColor5
                                                                              , inComment := ''
                                                                              , inSession := inSession
                                                                               ) AS tmp);
         END IF;

         -- ����� - Items
         vbProdColorItemsId:= (SELECT OL_Product.ObjectId
                               FROM ObjectLink AS OL_Product
                                    INNER JOIN ObjectLink AS OL_ProdColorGroup
                                                          ON OL_ProdColorGroup.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColorGroup.DescId        = zc_ObjectLink_ProdColorItems_ProdColorGroup()
                                                         AND OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId5
                                    INNER JOIN Object AS Object_ProdColorItems
                                                      ON Object_ProdColorItems.Id         = OL_Product.ObjectId
                                                     AND Object_ProdColorItems.ObjectCode = 5
                                                     AND Object_ProdColorItems.isErased   = FALSE
                               WHERE OL_Product.ChildObjectId = vbProductId
                                 AND OL_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                              );
         IF COALESCE (vbProdColorItemsId, 0) = 0
         THEN
             -- ��������
             vbProdColorItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColorItems (ioId              := 0
                                                                                            , inCode            := 5
                                                                                            , inName            := '5'
                                                                                            , inProductId       := vbProductId
                                                                                            , inProdColorGroupId:= vbProdColorGroupId5
                                                                                            , inProdColorId     := vbColorId
                                                                                            , inComment         := ''
                                                                                            , inSession         := inSession
                                                                                             ) AS tmp);
         END IF;

     END IF;


     -- 9.1.  ProdOptItemsId
     inOptionName1:= TRIM (inOptionName1);
     IF inOptionName1 <> ''
     THEN
         vbProdOptionsId:= 0;
         -- ����� - Options
         vbProdOptionsId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inOptionName1 AND Object.DescId = zc_Object_ProdOptions());
         IF COALESCE (vbProdOptionsId, 0) = 0
         THEN
             -- ��������
             vbProdOptionsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdOptions (ioId      := 0
                                                                                      , inCode    := 0
                                                                                      , inName    := inOptionName1
                                                                                      , inLevel   := 1
                                                                                      , inComment := ''
                                                                                      , inSession := inSession
                                                                                       ) AS tmp);
         END IF;

         -- ����� - Items
         vbProdOptItemsId:= (SELECT OL_Product.ObjectId
                             FROM ObjectLink AS OL_Product
                                  INNER JOIN Object AS Object_ProdOptItems
                                                    ON Object_ProdOptItems.Id         = OL_Product.ObjectId
                                                   AND Object_ProdOptItems.ObjectCode = 1
                                                   AND Object_ProdOptItems.isErased   = FALSE
                             WHERE OL_Product.ChildObjectId = vbProductId
                               AND OL_Product.DescId        = zc_ObjectLink_ProdOptItems_Product()
                            );
         IF COALESCE (vbProdOptItemsId, 0) = 0
         THEN
             -- ��������
             vbProdOptItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdOptItems (ioId              := 0
                                                                                        , inCode            := 1
                                                                                        , inName            := 'Option 1'
                                                                                        , inProductId       := vbProductId
                                                                                        , inProdOptionsId   := vbProdOptionsId
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
         vbProdOptionsId:= 0;
         -- ����� - Options
         vbProdOptionsId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inOptionName2 AND Object.DescId = zc_Object_ProdOptions());
         IF COALESCE (vbProdOptionsId, 0) = 0
         THEN
             -- ��������
             vbProdOptionsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdOptions (ioId      := 0
                                                                                      , inCode    := 0
                                                                                      , inName    := inOptionName2
                                                                                      , inLevel   := 2
                                                                                      , inComment := ''
                                                                                      , inSession := inSession
                                                                                       ) AS tmp);
         END IF;

         -- ����� - Items
         vbProdOptItemsId:= (SELECT OL_Product.ObjectId
                             FROM ObjectLink AS OL_Product
                                  INNER JOIN Object AS Object_ProdOptItems
                                                    ON Object_ProdOptItems.Id         = OL_Product.ObjectId
                                                   AND Object_ProdOptItems.ObjectCode = 2
                                                   AND Object_ProdOptItems.isErased   = FALSE
                             WHERE OL_Product.ChildObjectId = vbProductId
                               AND OL_Product.DescId        = zc_ObjectLink_ProdOptItems_Product()
                            );
         IF COALESCE (vbProdOptItemsId, 0) = 0
         THEN
             -- ��������
             vbProdOptItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdOptItems (ioId              := 0
                                                                                        , inCode            := 2
                                                                                        , inName            := 'Option 2'
                                                                                        , inProductId       := vbProductId
                                                                                        , inProdOptionsId   := vbProdOptionsId
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
         vbProdOptionsId:= 0;
         -- ����� - Options
         vbProdOptionsId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inOptionName3 AND Object.DescId = zc_Object_ProdOptions());
         IF COALESCE (vbProdOptionsId, 0) = 0
         THEN
             -- ��������
             vbProdOptionsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdOptions (ioId      := 0
                                                                                      , inCode    := 0
                                                                                      , inName    := inOptionName3
                                                                                      , inLevel   := 3
                                                                                      , inComment := ''
                                                                                      , inSession := inSession
                                                                                       ) AS tmp);
         END IF;

         -- ����� - Items
         vbProdOptItemsId:= (SELECT OL_Product.ObjectId
                             FROM ObjectLink AS OL_Product
                                  INNER JOIN Object AS Object_ProdOptItems
                                                    ON Object_ProdOptItems.Id         = OL_Product.ObjectId
                                                   AND Object_ProdOptItems.ObjectCode = 3
                                                   AND Object_ProdOptItems.isErased   = FALSE
                             WHERE OL_Product.ChildObjectId = vbProductId
                               AND OL_Product.DescId        = zc_ObjectLink_ProdOptItems_Product()
                            );
         IF COALESCE (vbProdOptItemsId, 0) = 0
         THEN
             -- ��������
             vbProdOptItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdOptItems (ioId              := 0
                                                                                        , inCode            := 3
                                                                                        , inName            := 'Option 3'
                                                                                        , inProductId       := vbProductId
                                                                                        , inProdOptionsId   := vbProdOptionsId
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
         vbProdOptionsId:= 0;
         -- ����� - Options
         vbProdOptionsId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inOptionName4 AND Object.DescId = zc_Object_ProdOptions());
         IF COALESCE (vbProdOptionsId, 0) = 0
         THEN
             -- ��������
             vbProdOptionsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdOptions (ioId      := 0
                                                                                      , inCode    := 0
                                                                                      , inName    := inOptionName4
                                                                                      , inLevel   := 4
                                                                                      , inComment := ''
                                                                                      , inSession := inSession
                                                                                       ) AS tmp);
         END IF;

         -- ����� - Items
         vbProdOptItemsId:= (SELECT OL_Product.ObjectId
                             FROM ObjectLink AS OL_Product
                                  INNER JOIN Object AS Object_ProdOptItems
                                                    ON Object_ProdOptItems.Id         = OL_Product.ObjectId
                                                   AND Object_ProdOptItems.ObjectCode = 4
                                                   AND Object_ProdOptItems.isErased   = FALSE
                             WHERE OL_Product.ChildObjectId = vbProductId
                               AND OL_Product.DescId        = zc_ObjectLink_ProdOptItems_Product()
                            );
         IF COALESCE (vbProdOptItemsId, 0) = 0
         THEN
             -- ��������
             vbProdOptItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdOptItems (ioId              := 0
                                                                                        , inCode            := 4
                                                                                        , inName            := 'Option 4'
                                                                                        , inProductId       := vbProductId
                                                                                        , inProdOptionsId   := vbProdOptionsId
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
         vbProdOptionsId:= 0;
         -- ����� - Options
         vbProdOptionsId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inOptionName5 AND Object.DescId = zc_Object_ProdOptions());
         IF COALESCE (vbProdOptionsId, 0) = 0
         THEN
             -- ��������
             vbProdOptionsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdOptions (ioId      := 0
                                                                                      , inCode    := 0
                                                                                      , inName    := inOptionName5
                                                                                      , inLevel   := 5
                                                                                      , inComment := ''
                                                                                      , inSession := inSession
                                                                                       ) AS tmp);
         END IF;

         -- ����� - Items
         vbProdOptItemsId:= (SELECT OL_Product.ObjectId
                             FROM ObjectLink AS OL_Product
                                  INNER JOIN Object AS Object_ProdOptItems
                                                    ON Object_ProdOptItems.Id         = OL_Product.ObjectId
                                                   AND Object_ProdOptItems.ObjectCode = 5
                                                   AND Object_ProdOptItems.isErased   = FALSE
                             WHERE OL_Product.ChildObjectId = vbProductId
                               AND OL_Product.DescId        = zc_ObjectLink_ProdOptItems_Product()
                            );
         IF COALESCE (vbProdOptItemsId, 0) = 0
         THEN
             -- ��������
             vbProdOptItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdOptItems (ioId              := 0
                                                                                        , inCode            := 5
                                                                                        , inName            := 'Option 5'
                                                                                        , inProductId       := vbProductId
                                                                                        , inProdOptionsId   := vbProdOptionsId
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
         vbProdOptionsId:= 0;
         -- ����� - Options
         vbProdOptionsId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inOptionName6 AND Object.DescId = zc_Object_ProdOptions());
         IF COALESCE (vbProdOptionsId, 0) = 0
         THEN
             -- ��������
             vbProdOptionsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdOptions (ioId      := 0
                                                                                      , inCode    := 0
                                                                                      , inName    := inOptionName6
                                                                                      , inLevel   := 6
                                                                                      , inComment := ''
                                                                                      , inSession := inSession
                                                                                       ) AS tmp);
         END IF;

         -- ����� - Items
         vbProdOptItemsId:= (SELECT OL_Product.ObjectId
                             FROM ObjectLink AS OL_Product
                                  INNER JOIN Object AS Object_ProdOptItems
                                                    ON Object_ProdOptItems.Id         = OL_Product.ObjectId
                                                   AND Object_ProdOptItems.ObjectCode = 6
                                                   AND Object_ProdOptItems.isErased   = FALSE
                             WHERE OL_Product.ChildObjectId = vbProductId
                               AND OL_Product.DescId        = zc_ObjectLink_ProdOptItems_Product()
                            );
         IF COALESCE (vbProdOptItemsId, 0) = 0
         THEN
             -- ��������
             vbProdOptItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdOptItems (ioId              := 0
                                                                                        , inCode            := 6
                                                                                        , inName            := 'Option 6'
                                                                                        , inProductId       := vbProductId
                                                                                        , inProdOptionsId   := vbProdOptionsId
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
         vbProdOptionsId:= 0;
         -- ����� - Options
         vbProdOptionsId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inOptionName7 AND Object.DescId = zc_Object_ProdOptions());
         IF COALESCE (vbProdOptionsId, 0) = 0
         THEN
             -- ��������
             vbProdOptionsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdOptions (ioId      := 0
                                                                                      , inCode    := 0
                                                                                      , inName    := inOptionName7
                                                                                      , inLevel   := 7
                                                                                      , inComment := ''
                                                                                      , inSession := inSession
                                                                                       ) AS tmp);
         END IF;

         -- ����� - Items
         vbProdOptItemsId:= (SELECT OL_Product.ObjectId
                             FROM ObjectLink AS OL_Product
                                  INNER JOIN Object AS Object_ProdOptItems
                                                    ON Object_ProdOptItems.Id         = OL_Product.ObjectId
                                                   AND Object_ProdOptItems.ObjectCode = 7
                                                   AND Object_ProdOptItems.isErased   = FALSE
                             WHERE OL_Product.ChildObjectId = vbProductId
                               AND OL_Product.DescId        = zc_ObjectLink_ProdOptItems_Product()
                            );
         IF COALESCE (vbProdOptItemsId, 0) = 0
         THEN
             -- ��������
             vbProdOptItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdOptItems (ioId              := 0
                                                                                        , inCode            := 7
                                                                                        , inName            := 'Option 7'
                                                                                        , inProductId       := vbProductId
                                                                                        , inProdOptionsId   := vbProdOptionsId
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
         vbProdOptionsId:= 0;
         -- ����� - Options
         vbProdOptionsId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inOptionName8 AND Object.DescId = zc_Object_ProdOptions());
         IF COALESCE (vbProdOptionsId, 0) = 0
         THEN
             -- ��������
             vbProdOptionsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdOptions (ioId      := 0
                                                                                      , inCode    := 0
                                                                                      , inName    := inOptionName8
                                                                                      , inLevel   := 8
                                                                                      , inComment := ''
                                                                                      , inSession := inSession
                                                                                       ) AS tmp);
         END IF;

         -- ����� - Items
         vbProdOptItemsId:= (SELECT OL_Product.ObjectId
                             FROM ObjectLink AS OL_Product
                                  INNER JOIN Object AS Object_ProdOptItems
                                                    ON Object_ProdOptItems.Id         = OL_Product.ObjectId
                                                   AND Object_ProdOptItems.ObjectCode = 8
                                                   AND Object_ProdOptItems.isErased   = FALSE
                             WHERE OL_Product.ChildObjectId = vbProductId
                               AND OL_Product.DescId        = zc_ObjectLink_ProdOptItems_Product()
                            );
         IF COALESCE (vbProdOptItemsId, 0) = 0
         THEN
             -- ��������
             vbProdOptItemsId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdOptItems (ioId              := 0
                                                                                        , inCode            := 8
                                                                                        , inName            := 'Option 8'
                                                                                        , inProductId       := vbProductId
                                                                                        , inProdOptionsId   := vbProdOptionsId
                                                                                        , inPriceIn         := inOptionPrice8 * 0.75
                                                                                        , inPriceOut        := inOptionPrice8
                                                                                        , inPartNumber      := inOptionPartNumber8
                                                                                        , inComment         := ''
                                                                                        , inSession         := inSession
                                                                                         ) AS tmp);
         END IF;

     END IF;


   --RAISE EXCEPTION '������.End OK';


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.10.20         *
*/


/*
select * from gpSelect_Object_ImportSettingsItems(inImportSettingsId := 1321 ,  inSession := '3');
select * from gpSelect_Object_ImportSettings( inSession := '3');

*/