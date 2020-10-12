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
    IN inStitchingcolor      TVarChar  ,
    IN inStitchingtype       TVarChar  ,
    IN inColor1              TVarChar  ,
    IN inColor2              TVarChar  ,
    IN inColor3              TVarChar  ,
    IN inColor4              TVarChar  ,
    IN inColor5              TVarChar  ,

    IN inOptionName1         TVarChar  ,
    IN inOptionPartnumber1   TVarChar  ,
    IN inOptionPrice1        TFloat    ,
    IN inOptionName2         TVarChar  ,
    IN inOptionPartnumber2   TVarChar  ,
    IN inOptionPrice2        TFloat    ,
    IN inOptionName3         TVarChar  ,
    IN inOptionPartnumber3   TVarChar  ,
    IN inOptionPrice3        TFloat    ,
    IN inOptionName4         TVarChar  ,
    IN inOptionPartnumber4   TVarChar  ,
    IN inOptionPrice4        TFloat    ,
    IN inOptionName5         TVarChar  ,
    IN inOptionPartnumber5   TVarChar  ,
    IN inOptionPrice5        TFloat    ,
    IN inOptionName6         TVarChar  ,
    IN inOptionPartnumber6   TVarChar  ,
    IN inOptionPrice6        TFloat    ,
    IN inOptionName7         TVarChar  ,
    IN inOptionPartnumber7   TVarChar  ,
    IN inOptionPrice7        TFloat    ,
    IN inOptionName8         TVarChar  ,
    IN inOptionPartnumber8   TVarChar  ,
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
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Member());


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
                                                                       , inCode    := 0
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
         vbProdEngineId := (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdModel (ioId      := 0
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
     IF COALESCE (vbProductId, 0) = 0
     THEN
         -- ��������
         vbProductId := (SELECT tmp.ioId FROM gpInsertUpdate_Object_Product (ioId            := 0
                                                                           , inCode          := NEXTVAL ('Object_Product_seq')
                                                                           , inName          := inBrandName || ' ' || inModelName || ' ' || inCIN
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
                                                                                         , inCode    := 0
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
                                                                                         , inCode    := 0
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
                                                                                         , inCode    := 0
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
                                                                                         , inCode    := 0
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
                                                                                         , inCode    := 0
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
                                                                              , inCode    := 0
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
                                    INNER JOIN ObjectLink AS OL_ProdColor
                                                          ON OL_ProdColor.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColor.DescId        = zc_ObjectLink_ProdColorItems_ProdColor()
                                                         AND OL_ProdColor.ChildObjectId = vbColorId
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
                                                                              , inCode    := 0
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
                                    INNER JOIN ObjectLink AS OL_ProdColor
                                                          ON OL_ProdColor.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColor.DescId        = zc_ObjectLink_ProdColorItems_ProdColor()
                                                         AND OL_ProdColor.ChildObjectId = vbColorId
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
                                                                              , inCode    := 0
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
                                                         AND OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId1
                                    INNER JOIN ObjectLink AS OL_ProdColor
                                                          ON OL_ProdColor.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColor.DescId        = zc_ObjectLink_ProdColorItems_ProdColor()
                                                         AND OL_ProdColor.ChildObjectId = vbColorId
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
     inFiberglassDeck:= TRIM (inFiberglassHull);
     IF inFiberglassDeck <> ''
     THEN
         vbColorId:= 0;
         -- ����� - Color
         vbColorId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inFiberglassDeck AND Object.DescId = zc_Object_ProdColor());
         IF COALESCE (vbColorId, 0) = 0
         THEN
             -- ��������
             vbColorId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColor (ioId      := 0
                                                                              , inCode    := 0
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
                                                         AND OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId1
                                    INNER JOIN ObjectLink AS OL_ProdColor
                                                          ON OL_ProdColor.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColor.DescId        = zc_ObjectLink_ProdColorItems_ProdColor()
                                                         AND OL_ProdColor.ChildObjectId = vbColorId
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
     inFiberglassSteeringConsole:= TRIM (inFiberglassHull);
     IF inFiberglassSteeringConsole <> ''
     THEN
         vbColorId:= 0;
         -- ����� - Color
         vbColorId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inFiberglassSteeringConsole AND Object.DescId = zc_Object_ProdColor());
         IF COALESCE (vbColorId, 0) = 0
         THEN
             -- ��������
             vbColorId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_ProdColor (ioId      := 0
                                                                              , inCode    := 0
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
                                                         AND OL_ProdColorGroup.ChildObjectId = vbProdColorGroupId1
                                    INNER JOIN ObjectLink AS OL_ProdColor
                                                          ON OL_ProdColor.ObjectId      = OL_Product.ObjectId
                                                         AND OL_ProdColor.DescId        = zc_ObjectLink_ProdColorItems_ProdColor()
                                                         AND OL_ProdColor.ChildObjectId = vbColorId
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

     -- ....................................................


     -- 9.1.  ProdOptItemsId
     inOptionName1:= TRIM (inOptionName1);
     IF inOptionName1 <> ''
     THEN
         vbProdOptionsId:= 0;
         -- ����� - Options
         vbProdOptionsId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inOptionName1 AND Object.DescId = zc_Object_ProdOption());
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
                                  INNER JOIN ObjectLink AS OL_ProdOptions
                                                        ON OL_ProdOptions.ObjectId      = OL_Product.ObjectId
                                                       AND OL_ProdOptions.DescId        = zc_ObjectLink_ProdOptItems_ProdOptions()
                                                       AND OL_ProdOptions.ChildObjectId = vbProdOptionsId
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
                                                                                        , inPartNumber      := inOptionPartnumber1
                                                                                        , inComment         := ''
                                                                                        , inSession         := inSession
                                                                                         ) AS tmp);
         END IF;

     END IF;


     RAISE EXCEPTION '������.End OK';


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