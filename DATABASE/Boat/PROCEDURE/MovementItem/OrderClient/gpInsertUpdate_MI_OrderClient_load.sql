-- Function: gpInsertUpdate_MI_OrderClient_load()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_OrderClient_load (Integer, Integer, TVarChar
                                                          , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                          , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                          , TVarChar
                                                           );
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_OrderClient_load (Integer, Integer, TVarChar, TVarChar
                                                          , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                          , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                          , TVarChar
                                                           );

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_OrderClient_load(
 INOUT ioProductId              Integer   , -- ���� ������� <������� ���������>
 INOUT ioMovementId_OrderClient Integer   , -- ���� ������� <��������>
    IN inInvNumber              TVarChar  , --
    IN inTitle                  TVarChar  , --
    IN inTitle1                 TVarChar  , --
    IN inValue1                 TVarChar  , --
    IN inTitle2                 TVarChar  , --
    IN inValue2                 TVarChar  , --
    IN inTitle3                 TVarChar  , --
    IN inValue3                 TVarChar  , --
    IN inTitle4                 TVarChar  , --
    IN inValue4                 TVarChar  , --
    IN inTitle5                 TVarChar  , --
    IN inValue5                 TVarChar  , --
    IN inTitle6                 TVarChar  , --
    IN inValue6                 TVarChar  , --
    IN inTitle7                 TVarChar  , --
    IN inValue7                 TVarChar  , --
    IN inTitle8                 TVarChar  , --
    IN inValue8                 TVarChar  , --
    IN inTitle9                 TVarChar  , --
    IN inValue9                 TVarChar  , --
    IN inTitle10                TVarChar  , --
    IN inValue10                TVarChar  , --
    IN inTitle11                TVarChar  , --
    IN inValue11                TVarChar  , --
    IN inTitle12                TVarChar  , --
    IN inValue12                TVarChar  , --
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbClientId   Integer;
   DECLARE vbModelId    Integer;
   DECLARE vbMovementItemId Integer;

   DECLARE vbProdOptItemsId     Integer;
   DECLARE vbProdOptionsId      Integer;
   DECLARE vbProdColorPatternId Integer;
   DECLARE vbGoodsId            Integer;
   DECLARE vbComment            TVarChar;
   DECLARE vbColor_title        TVarChar;
   
   DECLARE vbLISSE_MATT TVarChar;

BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpGetUserBySession (inSession);
     
     -- ������
     IF inValue3 = 'null' THEN inValue3:= ''; END IF;
     -- ������
     vbLISSE_MATT:= (SELECT Object.ValueData FROM Object WHERE Object.DescId = zc_Object_MaterialOptions()
                                                           AND (Object.ValueData ILIKE 'LISSE\/MATT'
                                                             OR Object.ValueData ILIKE 'LISSE/MATT'
                                                               ));

     /*IF inTitle ILIKE 'hypalon_secondary'
     THEN
         RAISE EXCEPTION '������.<%>.', inTitle;
     END IF;*/


     -- ������ - ��������
     IF inTitle ILIKE 'upholstery' AND inTitle2 ILIKE 'material_title' AND inValue2 ILIKE 'LIENZO' AND inValue3 ILIKE 'Black'
     THEN inValue2:= 'SILVERTEX�';
          IF inValue1 = 'b280_u_3' THEN inValue1:= 'b280_u_1'; END IF;

     --ELSEIF inTitle ILIKE 'upholstery' AND inTitle2 ILIKE 'material_title' AND inValue2 ILIKE 'DIAMANTE'
     --THEN inValue1:= 'b280_u_4';

     END IF;
     IF inValue1 = 'b280_t_4' AND inValue2 ILIKE 'SCRUBBED' THEN inValue1:= 'b280_t_1'; END IF;
     IF inValue1 = 'b280_t_4' AND inValue2 ILIKE 'BLEACHED' THEN inValue1:= 'b280_t_2'; END IF;

     -- ������ - ��������
     IF inTitle ILIKE 'upholstery' OR inTitle ILIKE 'teak'
        AND NOT EXISTS (SELECT 1
                        FROM Object
                             JOIN ObjectString AS OS ON OS.ObjectId = Object.Id AND OS.DescId = zc_ObjectString_Id_Site() AND OS.ValueData = inValue1
                             JOIN ObjectLink AS OL ON OL.ObjectId = Object.Id AND OL.DescId = zc_ObjectLink_ProdOptions_MaterialOptions()
                             JOIN Object AS Object_MaterialOptions ON Object_MaterialOptions.Id = OL.ChildObjectId
                                                                  -- �� ��������� MaterialOptions
                                                                  AND TRIM (Object_MaterialOptions.ValueData) ILIKE inValue2
                        WHERE Object.DescId = zc_Object_ProdOptions()
                          AND Object.isErased = FALSE
                       )
     THEN 
         -- ���������
         inValue12:= inValue1;
         -- !!!�������� ������, �.�. ������ MaterialOptions!!!
         inValue1:= COALESCE ((SELECT OS.ValueData
                               FROM Object
                                    JOIN ObjectString AS OS ON OS.ObjectId = Object.Id AND OS.DescId = zc_ObjectString_Id_Site()
                                    -- Model
                                    JOIN ObjectLink AS OL_Model
                                                    ON OL_Model.ObjectId      = Object.Id
                                                   AND OL_Model.DescId        = zc_ObjectLink_ProdOptions_Model()
                                                   -- ����� Model ��� ��� ProductId
                                                   AND OL_Model.ChildObjectId = (SELECT OL_find.ChildObjectId
                                                                                 FROM ObjectLink AS OL_find
                                                                                 WHERE OL_find.ObjectId = (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = ioMovementId_OrderClient AND MLO.DescId = zc_MovementLinkObject_Product())
                                                                                   AND OL_find.DescId   = zc_ObjectLink_Product_Model()
                                                                                )
                                    JOIN ObjectLink AS OL ON OL.ObjectId = Object.Id AND OL.DescId = zc_ObjectLink_ProdOptions_MaterialOptions()
                                    JOIN Object AS Object_MaterialOptions ON Object_MaterialOptions.Id = OL.ChildObjectId
                                                                         -- ����� ����� �� MaterialOptions
                                                                         AND TRIM (Object_MaterialOptions.ValueData) ILIKE inValue2
                               WHERE Object.DescId    = zc_Object_ProdOptions()
                                 AND Object.isErased  = FALSE
                              ), '');

--             RAISE EXCEPTION '������2.<%>  <%>.  <%> <%>.', inTitle, inValue4, inValue1, ioMovementId_OrderClient;

         -- ��������
         IF COALESCE (inValue1, '') = ''
         THEN
             RAISE EXCEPTION '������.������ ��� <%>. <%> + <%> + <%> �� �������', inValue12, inTitle, inValue2, inValue4;
         END IF;

     END IF;



     -- ����
     IF inTitle ILIKE 'accessories' AND inTitle4 ILIKE 'variant_title'
        and 1=0
     THEN 
             RAISE EXCEPTION '������.<%>  <%>.<%>.', inTitle, inValue4, inValue1;
     END IF;


     IF inTitle ILIKE 'accessories' AND inTitle4 ILIKE 'variant_title'
        -- ���� ������ ��� ������ Id_Site
        AND NOT EXISTS (SELECT 1 FROM Object JOIN ObjectString AS OS ON OS.ObjectId = Object.Id AND OS.DescId = zc_ObjectString_Id_Site() AND OS.ValueData = inValue1 WHERE Object.DescId = zc_Object_ProdOptions() AND Object.isErased = FALSE)
     THEN 
         -- ���������
         inValue12:= inValue1;
         -- !!!�������� ������, �.�. ������ Id_Site!!!
         inValue1:= COALESCE ((SELECT OS.ValueData
                               FROM Object
                                    JOIN ObjectString AS OS ON OS.ObjectId = Object.Id AND OS.DescId = zc_ObjectString_Id_Site()
                                    -- Model
                                    JOIN ObjectLink AS OL_Model
                                                    ON OL_Model.ObjectId      = Object.Id
                                                   AND OL_Model.DescId        = zc_ObjectLink_ProdOptions_Model()
                                                   -- ����� Model ��� ��� ProductId
                                                   AND OL_Model.ChildObjectId = (SELECT OL_find.ChildObjectId
                                                                                 FROM ObjectLink AS OL_find
                                                                                 WHERE OL_find.ObjectId = (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = ioMovementId_OrderClient AND MLO.DescId = zc_MovementLinkObject_Product())
                                                                                   AND OL_find.DescId   = zc_ObjectLink_Product_Model()
                                                                                )
                               WHERE Object.DescId    = zc_Object_ProdOptions()
                                 -- ����� ����� �� �������� �����
                                 AND TRIM (Object.ValueData) ILIKE TRIM (inValue4)
                                 AND Object.isErased  = FALSE
                              ), '');

--             RAISE EXCEPTION '������2.<%>  <%>.  <%> <%>.', inTitle, inValue4, inValue1, ioMovementId_OrderClient;

         -- ��������
         IF COALESCE (inValue1, '') = ''
         THEN
             RAISE EXCEPTION '������.������ ��� <%>. <%> + <%> + <%> �� �������', inValue12, inTitle, inValue2, inValue4;
         END IF;
         
     ELSEIF inTitle ILIKE 'light' OR inTitle ILIKE 'accessories' OR inTitle ILIKE 'title'
        -- ���� ��� ������ Id_Site + Name
        AND NOT EXISTS (SELECT 1 FROM Object JOIN ObjectString AS OS ON OS.ObjectId = Object.Id AND OS.DescId = zc_ObjectString_Id_Site() AND OS.ValueData = inValue1 WHERE Object.DescId = zc_Object_ProdOptions() AND TRIM (Object.ValueData) ILIKE TRIM (inValue2) AND Object.isErased = FALSE)
     THEN
         -- ���������
         inValue12:= inValue1;
     
         -- !!!�������� ������, �.�. ������ Id_Site!!!
         inValue1:= COALESCE ((SELECT OS.ValueData
                               FROM Object
                                    JOIN ObjectString AS OS ON OS.ObjectId = Object.Id AND OS.DescId = zc_ObjectString_Id_Site()
                                    -- Model
                                    JOIN ObjectLink AS OL_Model
                                                    ON OL_Model.ObjectId      = Object.Id
                                                   AND OL_Model.DescId        = zc_ObjectLink_ProdOptions_Model()
                                                   -- ����� Model ��� ��� ProductId
                                                   AND OL_Model.ChildObjectId = (SELECT OL_find.ChildObjectId
                                                                                 FROM ObjectLink AS OL_find
                                                                                 WHERE OL_find.ObjectId = (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = ioMovementId_OrderClient AND MLO.DescId = zc_MovementLinkObject_Product())
                                                                                   AND OL_find.DescId   = zc_ObjectLink_Product_Model()
                                                                                )
                               WHERE Object.DescId    = zc_Object_ProdOptions()
                                 -- ����� ����� �� �������� �����
                                 AND TRIM (Object.ValueData) ILIKE TRIM (inValue2)
                                 AND Object.isErased  = FALSE
                              ), '');

         -- ��������
         IF COALESCE (inValue1, '') = ''
         THEN
             RAISE EXCEPTION '������.������ ��� <%>. <%> + <%> + <%> �� �������', inValue12, inTitle, inValue2, inValue4;
         END IF;

     END IF;

     -- ������
     -- ioMovementId_OrderClient:= 648;

     -- 1. �����
     IF COALESCE (ioMovementId_OrderClient, 0) = 0 AND COALESCE (ioProductId, 0) = 0
     THEN
         ioMovementId_OrderClient:= (SELECT Movement.Id FROM Movement WHERE Movement.InvNumber = inInvNumber AND Movement.DescId = zc_Movement_OrderClient() AND Movement.StatusId <> zc_Enum_Status_Erased());
     END IF;

     -- 1. ���� ��� Id
     IF COALESCE (ioMovementId_OrderClient, 0) = 0
     THEN
         -- �������� - ����� ����� �� ������ ���� ��������
         IF EXISTS (SELECT 1 FROM Movement WHERE Movement.InvNumber = inInvNumber AND Movement.DescId = zc_Movement_OrderClient() AND Movement.StatusId <> zc_Enum_Status_Erased())
         THEN
             RAISE EXCEPTION '������.����� ���������� � <%> �� <%> ��� ��������.<%>.'
                            , inInvNumber
                            , (SELECT zfConvert_DateToString (Movement.OperDate) FROM Movement WHERE Movement.InvNumber = inInvNumber AND Movement.DescId = zc_Movement_OrderClient() AND Movement.StatusId <> zc_Enum_Status_Erased() ORDER BY 1 LIMIT 1)
                            , (SELECT Movement.Id FROM Movement WHERE Movement.InvNumber = inInvNumber AND Movement.DescId = zc_Movement_OrderClient() AND Movement.StatusId <> zc_Enum_Status_Erased() ORDER BY 1 LIMIT 1)
                             ;
         END IF;

         -- ��������
         ioMovementId_OrderClient:= lpInsertUpdate_Movement (ioMovementId_OrderClient, zc_Movement_OrderClient(), inInvNumber, CURRENT_DATE, NULL, vbUserId);

     ELSE
         -- �������� - ����� ����� �� ������ ���� ��������
         IF NOT EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = ioMovementId_OrderClient AND Movement.InvNumber = inInvNumber AND Movement.DescId = zc_Movement_OrderClient() AND Movement.StatusId <> zc_Enum_Status_Erased())
         THEN
             RAISE EXCEPTION '������.����� ���������� � <%> �� <%> �� ������ � � = <%>.'
                            , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = ioMovementId_OrderClient AND Movement.DescId = zc_Movement_OrderClient() AND Movement.StatusId <> zc_Enum_Status_Erased() ORDER BY 1 LIMIT 1)
                            , (SELECT zfConvert_DateToString (Movement.OperDate) FROM Movement WHERE Movement.Id = ioMovementId_OrderClient AND Movement.DescId = zc_Movement_OrderClient() AND Movement.StatusId <> zc_Enum_Status_Erased() ORDER BY 1 LIMIT 1)
                            , inInvNumber
                             ;
         END IF;

     END IF;


     -- 2. ���� ������� � ����� (Basis+options)
     IF inTitle ILIKE 'full_price'
     THEN
         -- ��������
         IF zfConvert_StringToFloat (inValue1) <= 0
         THEN
             RAISE EXCEPTION '������.�� ����������� �������� <���� ������� � ����� (Basis+options)> = <%>.'
                            , inValue1
                             ;
         END IF;
         -- ��������� ��������
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_OperPrice_load(), ioMovementId_OrderClient, zfConvert_StringToFloat (inValue1));

     END IF;


     -- 3. ����� ��������� � �����
     IF inTitle ILIKE 'transport_preparation_price'
     THEN
         -- ��������
         IF zfConvert_StringToFloat (inValue1) <= 0
         THEN
             RAISE EXCEPTION '������.�� ����������� �������� <����� ���������> = <%>.', inValue1;
         END IF;
         -- ��������� ��������
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TransportSumm_load(), ioMovementId_OrderClient, zfConvert_StringToFloat (inValue1));

     END IF;


     -- 4. ������
     IF inTitle ILIKE 'client'
     THEN
         -- ��������
         IF inTitle1 ILIKE 'name' AND TRIM (inValue1) = ''
         THEN
             RAISE EXCEPTION '������.�� ����������� �������� ������ <Name> = <%> <phone> = <%> <email> = <%>.', inValue1, inValue2, inValue3;
         END IF;

         -- ����� �� � ��������
         IF inTitle2 ILIKE 'phone' AND TRIM (inValue2) <> ''
         THEN
             -- ��������-1
             IF 1 < (SELECT COUNT(*) FROM ObjectString AS OS JOIN Object ON Object.Id = OS.ObjectId AND TRIM (Object.ValueData) ILIKE TRIM (inValue1) WHERE OS.ValueData ILIKE inValue2 AND OS.DescId = zc_ObjectString_Client_Phone())
             THEN
                 RAISE EXCEPTION '������.� �������� = <%> ������ � ������ ��������.', inValue2;
             END IF;
             -- �����-1
             vbClientId:= (SELECT OS.ObjectId FROM ObjectString AS OS JOIN Object ON Object.Id = OS.ObjectId AND TRIM (Object.ValueData) ILIKE TRIM (inValue1) WHERE OS.ValueData ILIKE inValue2 AND OS.DescId = zc_ObjectString_Client_Phone());

             -- ���� �� �����
             IF COALESCE (vbClientId, 0) = 0
             THEN
                 -- ��������-2
                 IF 1 < (SELECT COUNT(*) FROM ObjectString AS OS JOIN Object ON Object.Id = OS.ObjectId AND TRIM (Object.ValueData) ILIKE TRIM (inValue1) WHERE OS.ValueData ILIKE inValue2 AND OS.DescId = zc_ObjectString_Client_Mobile())
                 THEN
                     RAISE EXCEPTION '������.� �������� = <%> ������ � ������ ��������.', inValue2;
                 END IF;
                 -- �����-2
                 vbClientId:= (SELECT OS.ObjectId FROM ObjectString AS OS JOIN Object ON Object.Id = OS.ObjectId AND TRIM (Object.ValueData) ILIKE TRIM (inValue1) WHERE OS.ValueData ILIKE inValue2 AND OS.DescId = zc_ObjectString_Client_Mobile());

             END IF;

         END IF;

         -- ����� �� ����������� �����
         IF COALESCE (vbClientId, 0) = 0 AND inTitle3 ILIKE 'email' AND TRIM (inValue3) <> ''
         THEN
             -- ��������
             IF 1 < (SELECT COUNT(*) FROM ObjectString AS OS JOIN Object ON Object.Id = OS.ObjectId AND TRIM (Object.ValueData) ILIKE TRIM (inValue1) WHERE OS.ValueData ILIKE inValue3 AND OS.DescId = zc_ObjectString_Client_Email())
             THEN
                 RAISE EXCEPTION '������.����������� ����� = <%> ������� � ������ ��������.', inValue3;
             END IF;

             -- �����
             vbClientId:= (SELECT OS.ObjectId FROM ObjectString AS OS JOIN Object ON Object.Id = OS.ObjectId AND TRIM (Object.ValueData) ILIKE TRIM (inValue1) WHERE OS.ValueData ILIKE inValue3 AND OS.DescId = zc_ObjectString_Client_Email());

         END IF;

         -- ����� �� ��������
         IF COALESCE (vbClientId, 0) = 0 AND inTitle1 ILIKE 'name' AND TRIM (inValue1) <> ''
         THEN
             vbClientId:= (SELECT Object.Id
                           FROM Object
                                LEFT JOIN ObjectString AS OS_Phone  ON OS_Phone.ObjectId  = Object.Id AND OS_Phone.DescId  = zc_ObjectString_Client_Phone()
                                LEFT JOIN ObjectString AS OS_Mobile ON OS_Mobile.ObjectId = Object.Id AND OS_Mobile.DescId = zc_ObjectString_Client_Mobile()
                                LEFT JOIN ObjectString AS OS_Email  ON OS_Email.ObjectId  = Object.Id AND OS_Email.DescId  = zc_ObjectString_Client_Email()
                           WHERE Object.ValueData ILIKE inValue1
                             AND Object.DescId = zc_Object_Client()
                             AND COALESCE (OS_Phone.ValueData,  '') = ''
                             AND COALESCE (OS_Mobile.ValueData, '') = ''
                             AND COALESCE (OS_Email.ValueData,  '') = ''
                          );
         END IF;

         -- ���� �� �����
         IF COALESCE (vbClientId, 0) = 0
         THEN
             -- �������� ������������ ��� �������� <�������� >
             PERFORM lpCheckUnique_Object_ValueData (vbClientId, zc_Object_Client(), inValue1, vbUserId);

             -- ��������
             vbClientId := lpInsertUpdate_Object (vbClientId, zc_Object_Client(), 0, inValue1);

             -- � ��������
             IF inTitle2 ILIKE 'phone' AND TRIM (inValue2) <> ''
             THEN
                 -- ��������� ��������
                 PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Client_Phone(), vbClientId, inValue2);
             END IF;

             -- ����������� �����
             IF inTitle3 ILIKE 'email' AND TRIM (inValue3) <> ''
             THEN
                 -- ��������� ��������
                 PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Client_Email(), vbClientId, inValue3);
             END IF;

             -- ����������� �����
             IF inTitle4 ILIKE 'comment' AND TRIM (inValue4) <> ''
             THEN
                 -- ��������� ��������
                 PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Client_Comment(), vbClientId, inValue4);
             END IF;

         END IF;

         -- �������� ����� ������� - ��������� ����� � <�� ����>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioMovementId_OrderClient, vbClientId);

     END IF;


     -- 5. �����
     IF inTitle ILIKE 'model'
     THEN
         -- ��������
         IF 1 < (SELECT COUNT(*)
                 FROM Object AS Object_Model
                 WHERE Object_Model.DescId = zc_Object_ProdModel()
                   AND inValue2 ILIKE ('%' || Object_Model.ValueData || '%')
                   AND inTitle2 ILIKE 'title'
                   AND TRIM (inValue2) <> ''
                )
         THEN
             RAISE EXCEPTION '������.������ = <%> ������� � �������.', inValue2;
         END IF;

         -- �����
         vbModelId:= (SELECT Object_Model.Id
                      FROM Object AS Object_Model
                      WHERE Object_Model.DescId = zc_Object_ProdModel()
                        AND inValue2 ILIKE ('%' || Object_Model.ValueData || '%')
                        AND inTitle2 ILIKE 'title'
                        AND TRIM (inValue2) <> ''
                     );
         -- ��������
         IF COALESCE (vbModelId, 0) = 0
         THEN
             RAISE EXCEPTION '������.������ = <%> �� �������.', inValue2;
         END IF;

         -- ��������
         IF 1 < (SELECT COUNT(*)
                 FROM Object AS Object_ReceiptProdModel
                      INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                               ON ObjectBoolean_Main.ObjectId  = Object_ReceiptProdModel.Id
                                              AND ObjectBoolean_Main.DescId    = zc_ObjectBoolean_ReceiptProdModel_Main()
                                              AND ObjectBoolean_Main.ValueData = TRUE
                      INNER JOIN ObjectLink AS ObjectLink_Model
                                            ON ObjectLink_Model.ObjectId      = Object_ReceiptProdModel.Id
                                           AND ObjectLink_Model.DescId        = zc_ObjectLink_ReceiptProdModel_Model()
                                           AND ObjectLink_Model.ChildObjectId = vbModelId
                 WHERE Object_ReceiptProdModel.DescId = zc_Object_ReceiptProdModel()
                   AND Object_ReceiptProdModel.isErased = FALSE
                )
         THEN
             RAISE EXCEPTION '������.Object_ReceiptProdModel ��� ������ = <%> <%> .', lfGet_Object_ValueData_sh (vbModelId), vbModelId;
         END IF;

         -- �����
         ioProductId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = ioMovementId_OrderClient AND MLO.DescId = zc_MovementLinkObject_Product());


         -- 5.1. ��������� ��������
         ioProductId:= (SELECT gpInsertUpdate_Object_Product
                                               (ioId                    := ioProductId
                                              , inCode                  := COALESCE ((SELECT Object.ObjectCode FROM Object WHERE Object.Id = ioProductId), lfGet_ObjectCode(0, zc_Object_Product()))
                                              , inName                  := (SELECT Object.ValueData  FROM Object WHERE Object.Id = ioProductId)
                                              , inBrandId               := (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbModelId AND OL.DescId = zc_ObjectLink_ProdModel_Brand())
                                              , inModelId               := vbModelId
                                              , inEngineId              := NULL
                                              , inReceiptProdModelId    :=  (SELECT Object_ReceiptProdModel.Id        AS ReceiptProdModelId
                                                                             FROM Object AS Object_ReceiptProdModel
                                                                                  INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                                                                           ON ObjectBoolean_Main.ObjectId  = Object_ReceiptProdModel.Id
                                                                                                          AND ObjectBoolean_Main.DescId    = zc_ObjectBoolean_ReceiptProdModel_Main()
                                                                                                          AND ObjectBoolean_Main.ValueData = TRUE
                                                                                  INNER JOIN ObjectLink AS ObjectLink_Model
                                                                                                        ON ObjectLink_Model.ObjectId      = Object_ReceiptProdModel.Id
                                                                                                       AND ObjectLink_Model.DescId        = zc_ObjectLink_ReceiptProdModel_Model()
                                                                                                       AND ObjectLink_Model.ChildObjectId = vbModelId
                                                                             WHERE Object_ReceiptProdModel.DescId = zc_Object_ReceiptProdModel()
                                                                               AND Object_ReceiptProdModel.isErased = FALSE
                                                                            )
                                              , inClientId              := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.DescId = zc_MovementLinkObject_From() AND MLO.MovementId = ioMovementId_OrderClient)
                                              , inIsBasicConf           := -- �������� ������� ������������
                                                                           COALESCE ((SELECT OB.ValueData FROM ObjectBoolean AS OB WHERE OB.DescId = zc_ObjectBoolean_Product_BasicConf() AND OB.ObjectId = ioProductId)
                                                                                   , TRUE)
                                              , inIsProdColorPattern    := -- ������������� �������� ��� Items Boat Structure
                                                                           NOT EXISTS (SELECT 1
                                                                                       FROM Object AS Object_ProdColorItems
                                                                                            -- �����
                                                                                            INNER JOIN ObjectLink AS ObjectLink_Product
                                                                                                                  ON ObjectLink_Product.ObjectId      = Object_ProdColorItems.Id
                                                                                                                 AND ObjectLink_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                                                                                                                 AND ObjectLink_Product.ChildObjectId = ioProductId
                                                                                            -- ����� �������
                                                                                            INNER JOIN ObjectFloat AS ObjectFloat_MovementId_OrderClient
                                                                                                                   ON ObjectFloat_MovementId_OrderClient.ObjectId  = Object_ProdColorItems.Id
                                                                                                                  AND ObjectFloat_MovementId_OrderClient.DescId    = zc_ObjectFloat_ProdColorItems_OrderClient()
                                                                                                                  AND ObjectFloat_MovementId_OrderClient.ValueData = ioMovementId_OrderClient
                                                                                       WHERE Object_ProdColorItems.DescId   = zc_Object_ProdColorItems()
                                                                                         AND Object_ProdColorItems.isErased = FALSE
                                                                                      )
                                              , inHours                 := 0
                                              , inDiscountTax           := 0
                                              , inDiscountNextTax       := 0
                                              , inDateStart             := NULL
                                              , inDateBegin             := NULL
                                              , inDateSale              := NULL
                                              , inCIN                   := '-'
                                              , inEngineNum             := ''
                                              , inComment               := ''

                                              , inMovementId_OrderClient:= ioMovementId_OrderClient
                                              , inInvNumber_OrderClient := (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = ioMovementId_OrderClient)
                                              , inOperDate_OrderClient  := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = ioMovementId_OrderClient)

                                              , inMovementId_Invoice    := NULL
                                              , inInvNumber_Invoice     := ''
                                              , inOperDate_Invoice      := NULL
                                              , inAmountIn_Invoice      := 0
                                              , inAmountOut_Invoice     := 0

                                              , inSession               := inSession
                                               ));

         --  ���� ����� ��� ������
         IF COALESCE (ioMovementId_OrderClient, 0) = 0
         THEN
             -- �����
             ioMovementId_OrderClient:= (SELECT MLO.MovementId FROM MovementLinkObject AS MLO WHERE MLO.ObjectId = ioProductId AND MLO.DescId = zc_MovementLinkObject_Product());
             -- ��������
             IF COALESCE (ioMovementId_OrderClient, 0) = 0
             THEN
                 RAISE EXCEPTION '������.�������� �� ������ ��� ����� <%>.', lfGet_Object_ValueData_sh (ioProductId);
             END IF;
         END IF;

         -- ��� ��� - ������ ��� ���������
         ioMovementId_OrderClient:= lpInsertUpdate_Movement_OrderClient(ioId                 := ioMovementId_OrderClient
                                                                      , inInvNumber          := (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = ioMovementId_OrderClient)
                                                                      , inInvNumberPartner   := (SELECT MS.ValueData FROM MovementString AS MS WHERE MS.DescId = zc_MovementString_InvNumberPartner() AND MS.MovementId = ioMovementId_OrderClient)
                                                                      , inOperDate           := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = ioMovementId_OrderClient)
                                                                      , inPriceWithVAT       := COALESCE ((SELECT MB.ValueData FROM MovementBoolean AS MB WHERE MB.DescId = zc_MovementBoolean_PriceWithVAT() AND MB.MovementId = ioMovementId_OrderClient), FALSE)
                                                                      , inVATPercent         := (SELECT ObjectFloat_TaxKind_Value.ValueData
                                                                                                 FROM ObjectLink AS ObjectLink_TaxKind
                                                                                                      LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                                                                                                            ON ObjectFloat_TaxKind_Value.ObjectId = ObjectLink_TaxKind.ChildObjectId
                                                                                                                           AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()
                                                                                                 WHERE ObjectLink_TaxKind.ObjectId = (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.DescId = zc_MovementLinkObject_From() AND MLO.MovementId = ioMovementId_OrderClient)
                                                                                                   AND ObjectLink_TaxKind.DescId = zc_ObjectLink_Client_TaxKind()
                                                                                                )
                                                                      , inDiscountTax        := COALESCE ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = ioMovementId_OrderClient AND MF.DescId = zc_MovementFloat_DiscountTax()), 0)
                                                                      , inDiscountNextTax    := COALESCE ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = ioMovementId_OrderClient AND MF.DescId = zc_MovementFloat_DiscountNextTax()), 0)
                                                                      , inFromId             := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.DescId = zc_MovementLinkObject_From() AND MLO.MovementId = ioMovementId_OrderClient)
                                                                      , inToId               := COALESCE ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.DescId = zc_MovementLinkObject_To() AND MLO.MovementId = ioMovementId_OrderClient), zc_Unit_Production())
                                                                      , inPaidKindId         := COALESCE ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.DescId = zc_MovementLinkObject_PaidKind() AND MLO.MovementId = ioMovementId_OrderClient), zc_Enum_PaidKind_FirstForm())
                                                                      , inProductId          := ioProductId
                                                                      , inMovementId_Invoice := (SELECT MLM.MovementChildId FROM MovementLinkMovement AS MLM WHERE MLM.DescId = zc_MovementLinkMovement_Invoice() AND MLM.MovementId = ioMovementId_OrderClient)
                                                                      , inComment            := COALESCE ((SELECT MS.ValueData FROM MovementString AS MS WHERE MS.DescId = zc_MovementString_Comment() AND MS.MovementId = ioMovementId_OrderClient), '1')
                                                                      , inUserId             := vbUserId
                                                                       );

         -- ����� ���������
         vbMovementItemId:= (SELECT MI.Id FROM MovementItem AS MI WHERE MI.MovementId = ioMovementId_OrderClient AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE);

         -- 5.2. ��������
         IF NOT EXISTS (SELECT 1 FROM MovementFloat AS MF WHERE MF.MovementId = ioMovementId_OrderClient AND MF.DescId = zc_MovementFloat_OperPrice_load() AND MF.ValueData > 0)
         THEN
             RAISE EXCEPTION '������.�� ����������� �������� <���� ������� � ����� (Basis+options)> = <%>.'
                            , (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = ioMovementId_OrderClient AND MF.DescId = zc_MovementFloat_OperPrice_load() AND MF.ValueData > 0)
                             ;
         END IF;
         -- 5.2. ��������� <���� ������� � ����� (Basis+options)>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice_load(), vbMovementItemId, (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = ioMovementId_OrderClient AND MF.DescId = zc_MovementFloat_OperPrice_load() AND MF.ValueData > 0));


         -- 5.3. ��������
         IF inTitle3 ILIKE 'price' AND zfConvert_StringToFloat (inValue3) <= 0
         THEN
             RAISE EXCEPTION '������.�� ����������� �������� <������� ���� ������� ������ � �����> = <%>.', inValue3;
         END IF;
         -- 5.3. ��������� <������� ���� ������� ������ � �����>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_BasisPrice_load(), vbMovementItemId, zfConvert_StringToFloat (inValue3));

     END IF;




     -- 6. �����
     IF inTitle ILIKE 'hypalon_primary'
     OR inTitle ILIKE 'hypalon_secondary'
     OR inTitle ILIKE 'moldings'
     OR inTitle ILIKE 'upholstery'
     OR inTitle ILIKE 'teak'
     OR inTitle ILIKE 'hull'
     OR inTitle ILIKE 'deck'
     OR inTitle ILIKE 'sconsole'
     OR inTitle ILIKE 'devices'
     OR inTitle ILIKE 'light'
     OR inTitle ILIKE 'accessories'
     OR inTitle ILIKE 'engine'
     OR inTitle ILIKE 'title'

     THEN
         -- 6.1. ����� ProdOptions
         IF inTitle1 ILIKE 'id' AND TRIM (inValue1) <> ''
         THEN
             vbProdOptionsId:= (SELECT Object.Id FROM Object JOIN ObjectString AS OS ON OS.ObjectId = Object.Id AND OS.DescId = zc_ObjectString_Id_Site() AND OS.ValueData = inValue1 WHERE Object.DescId = zc_Object_ProdOptions());
         END IF;
         -- 6.1. ��������
         IF COALESCE (vbProdOptionsId, 0) = 0
         THEN
             RAISE EXCEPTION '������.�� ������� �������� ����� � Key = <%>.', inValue1;
         END IF;
         -- 6.1. �������� - category_title+inValue3 ������ ��������������� MaterialOptionsId
         IF (inTitle ILIKE 'hypalon_primary' OR inTitle ILIKE 'hypalon_secondary')
            AND NOT EXISTS (SELECT 1 FROM ObjectLink AS OL JOIN Object ON Object.Id = OL.ChildObjectId AND Object.ValueData ILIKE CASE WHEN COALESCE (inValue3, '') = '' THEN vbLISSE_MATT ELSE inValue3 END AND Object.isErased = FALSE WHERE OL.ObjectId = vbProdOptionsId  AND OL.DescId = zc_ObjectLink_ProdOptions_MaterialOptions())
            -- !!!���� MaterialOptions �� ������!!!
          --AND COALESCE (inValue3, '') <> ''
         THEN
             -- ���������
             inValue12:= vbProdOptionsId :: TVarChar;
             -- !!!�������� ������, �.�. ������ MaterialOptions!!!
             vbProdOptionsId:= COALESCE ((SELECT OL.ObjectId
                                          FROM ObjectLink AS OL
                                               -- ������ MaterialOptions
                                               JOIN Object AS Object_MaterialOptions ON Object_MaterialOptions.Id        = OL.ChildObjectId
                                                                                    -- ����� ������ ��������
                                                                                    AND Object_MaterialOptions.ValueData ILIKE CASE WHEN COALESCE (inValue3, '') = '' THEN vbLISSE_MATT ELSE inValue3 END
                                                                                    AND Object_MaterialOptions.isErased  = FALSE
                                               -- Boat Structure
                                               JOIN ObjectLink AS OL_ProdColorPattern
                                                               ON OL_ProdColorPattern.ObjectId      = OL.ObjectId
                                                              AND OL_ProdColorPattern.DescId        = zc_ObjectLink_ProdOptions_ProdColorPattern()
                                                              -- ����� Boat Structure ��� ����� ��� vbProdOptionsId
                                                              AND OL_ProdColorPattern.ChildObjectId = (SELECT OL_find.ChildObjectId
                                                                                                       FROM ObjectLink AS OL_find
                                                                                                       WHERE OL_find.ObjectId = vbProdOptionsId
                                                                                                        AND OL_find.DescId    = zc_ObjectLink_ProdOptions_ProdColorPattern()
                                                                                                      )
                                               -- Model
                                               JOIN ObjectLink AS OL_Model
                                                               ON OL_Model.ObjectId      = OL.ObjectId
                                                              AND OL_Model.DescId        = zc_ObjectLink_ProdOptions_Model()
                                                              -- ����� Model ��� ����� ��� vbProdOptionsId
                                                              AND OL_Model.ChildObjectId = (SELECT OL_find.ChildObjectId
                                                                                            FROM ObjectLink AS OL_find
                                                                                            WHERE OL_find.ObjectId = vbProdOptionsId
                                                                                              AND OL_find.DescId    = zc_ObjectLink_ProdOptions_Model()
                                                                                           )
                                          WHERE OL.DescId = zc_ObjectLink_ProdOptions_MaterialOptions()
                                         ), 0);

             -- 6.1. ��������
             IF COALESCE (vbProdOptionsId, 0) = 0
             THEN
                 RAISE EXCEPTION '������.�� ������� ����� � Key = <%> + MaterialOptions = <%>. ����� ������ ��� <%>(<%>)', inValue1, CASE WHEN COALESCE (inValue3, '') = '' THEN vbLISSE_MATT ELSE inValue3 END, lfGet_Object_ValueData (inValue12 :: Integer), inValue12;
             END IF;
             /*RAISE EXCEPTION '������.��� <%><%> ��������� ����� ������ ���� = <%> � �������� ����������� = <%>.'
                            , inValue1, lfGet_Object_ValueData_sh (vbProdOptionsId)
                            , lfGet_Object_ValueData_sh ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbProdOptionsId  AND OL.DescId = zc_ObjectLink_ProdOptions_MaterialOptions()))
                            , inValue3
                             ;*/
         END IF;
         -- 6.1. �������� - material_title+inValue2 ������ ��������������� MaterialOptionsId
         IF (inTitle ILIKE 'upholstery' OR inTitle ILIKE 'teak')
            AND NOT EXISTS (SELECT 1 FROM ObjectLink AS OL JOIN Object ON Object.Id = OL.ChildObjectId AND Object.ValueData ILIKE inValue2 AND Object.isErased = FALSE WHERE OL.ObjectId = vbProdOptionsId  AND OL.DescId = zc_ObjectLink_ProdOptions_MaterialOptions())
         THEN
             RAISE EXCEPTION '������.��� <%><%> ��������� ����� ������ ���� = <%> � �������� ����������� = <%>.'
                            , inValue1, lfGet_Object_ValueData_sh (vbProdOptionsId)
                            , lfGet_Object_ValueData_sh ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbProdOptionsId  AND OL.DescId = zc_ObjectLink_ProdOptions_MaterialOptions()))
                            , inValue2
                             ;
         END IF;
         -- 6.1. �������� - Name Options ������ ���������������
         IF (inTitle ILIKE 'devices' OR inTitle ILIKE 'light' OR inTitle ILIKE 'accessories' OR inTitle ILIKE 'title')
            AND NOT EXISTS (SELECT 1 FROM Object WHERE Object.Id = vbProdOptionsId AND Object.ValueData ILIKE inValue2 AND Object.isErased = FALSE)
         THEN
             -- !!!�������� ������, �.�. ������ Name!!!
             vbProdOptionsId:= COALESCE ((SELECT Object.Id
                                          FROM Object
                                               -- Model
                                               JOIN ObjectLink AS OL_Model
                                                               ON OL_Model.ObjectId      = Object.Id
                                                              AND OL_Model.DescId        = zc_ObjectLink_ProdOptions_Model()
                                                              -- ����� Model ��� ����� ��� vbProdOptionsId
                                                              AND OL_Model.ChildObjectId = (SELECT OL_find.ChildObjectId
                                                                                            FROM ObjectLink AS OL_find
                                                                                            WHERE OL_find.ObjectId = vbProdOptionsId
                                                                                              AND OL_find.DescId    = zc_ObjectLink_ProdOptions_Model()
                                                                                           )
                                          WHERE Object.DescId    = zc_Object_ProdOptions()
                                            -- ����� ������ ��������
                                            AND Object.ValueData ILIKE CASE WHEN inTitle4 ILIKE 'variant_title' THEN inValue4 ELSE inValue2 END
                                            AND Object.isErased  = FALSE
                                         ), 0);

             -- 6.1. ��������
             IF COALESCE (vbProdOptionsId, 0) = 0
             THEN
                 RAISE EXCEPTION '������.�� ������� ����� � Key = <%> + Name = <%>.', inValue1, CASE WHEN inTitle4 ILIKE 'variant_title' THEN inValue4 ELSE inValue2 END;
             END IF;
             /*RAISE EXCEPTION '������.��� <%> ������� ����� ������ ���� = <%> � �������� ����������� = <%>.'
                            , inValue1, lfGet_Object_ValueData_sh (vbProdOptionsId)
                            , inValue2
                             ;*/
         END IF;


         -- 6.2.1. ����� Boat Structure
         vbProdColorPatternId:= (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbProdOptionsId AND OL.DescId = zc_ObjectLink_ProdOptions_ProdColorPattern());
         -- 6.2.2. ����� ����
         vbColor_title:= CASE WHEN inTitle2 ILIKE 'color_title' THEN inValue2
                              WHEN inTitle3 ILIKE 'color_title' THEN inValue3
                              WHEN inTitle4 ILIKE 'color_title' THEN inValue4
                              WHEN inTitle5 ILIKE 'color_title' THEN inValue5
                              WHEN inTitle6 ILIKE 'color_title' THEN inValue6
                              WHEN inTitle7 ILIKE 'color_title' THEN inValue7
                         END;


         -- 6.2.3. �����
         IF vbProdColorPatternId > 0
            AND (inTitle ILIKE 'hypalon_primary'
              OR inTitle ILIKE 'hypalon_secondary'
              OR inTitle ILIKE 'upholstery'
                )
         THEN
             -- 6.2.3. ���� ���� ����� �� ��� � ������ � �����
             IF EXISTS (SELECT 1
                        FROM ObjectLink AS OL
                               JOIN ObjectLink AS OL_ProdColor
                                               ON OL_ProdColor.ObjectId = OL.ChildObjectId
                                              AND OL_ProdColor.DescId   = zc_ObjectLink_Goods_ProdColor()
                               JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = OL_ProdColor.ChildObjectId
                                                              -- ��� �� ����
                                                              AND Object_ProdColor.ValueData ILIKE vbColor_title
                        WHERE OL.ObjectId = vbProdOptionsId
                          AND OL.DescId   = zc_ObjectLink_ProdOptions_Goods()
                       )
             THEN
                  -- 6.2.3. ����� � ������ ��� Boat Structure
                  vbGoodsId:= (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbProdOptionsId AND OL.DescId = zc_ObjectLink_ProdOptions_Goods());

             -- ����� ����� ������
             ELSE
                  IF inTitle ILIKE 'upholstery'
                  THEN
                      -- 6.2.3. ����� ������������� ����� ���� + GoodsName = MaterialOptions
                      vbGoodsId:= (SELECT Object_Goods.Id
                                   FROM Object AS Object_ProdColor
                                        JOIN ObjectLink AS OL_ProdColor
                                                        ON OL_ProdColor.DescId    = zc_ObjectLink_Goods_ProdColor()
                                                       AND OL_ProdColor.ChildObjectId = Object_ProdColor.Id
                                        JOIN Object AS Object_Goods ON Object_Goods.Id       = OL_ProdColor.ObjectId
                                                                   AND Object_Goods.isErased  = FALSE
                                                                   -- MaterialOptions
                                                                   AND CASE WHEN inTitle2 ILIKE 'material_title' THEN inValue2
                                                                            WHEN inTitle3 ILIKE 'material_title' THEN inValue3
                                                                     --END ILIKE (TRIM (Object_Goods.ValueData))
                                                                       END ILIKE (TRIM (Object_Goods.ValueData) || '%')
                                   WHERE Object_ProdColor.DescId    = zc_Object_ProdColor()
                                     -- � ����� ������
                                     AND Object_ProdColor.ValueData ILIKE vbColor_title
                                  );

                      -- 6.2.3. ��������
                      IF COALESCE (vbGoodsId, 0) = 0
                      THEN
                          RAISE EXCEPTION '������.�� ������� �������� �������������� = <%> � ���� = <%>.'
                                         , CASE WHEN inTitle2 ILIKE 'material_title' THEN inValue2
                                                WHEN inTitle3 ILIKE 'material_title' THEN inValue3
                                           END
                                         , vbColor_title
                                          ;
                      END IF;

                  ELSEIF inTitle ILIKE 'hypalon_primary'
                      OR inTitle ILIKE 'hypalon_secondary'
                  THEN

                      -- 6.2.3. ��������
                      IF 1 < (SELECT COUNT(*)
                              FROM Object AS Object_ProdColor
                                   JOIN ObjectLink AS OL_ProdColor
                                                   ON OL_ProdColor.DescId        = zc_ObjectLink_Goods_ProdColor()
                                                  AND OL_ProdColor.ChildObjectId = Object_ProdColor.Id
                                   JOIN Object AS Object_Goods ON Object_Goods.Id               = OL_ProdColor.ObjectId
                                                              AND Object_Goods.isErased         = FALSE
                                                              AND TRIM (Object_Goods.ValueData) ILIKE 'hypalon'
                              WHERE Object_ProdColor.DescId    = zc_Object_ProdColor()
                                -- � ����� ������
                                AND Object_ProdColor.ValueData ILIKE vbColor_title
                             )
                      THEN
                          RAISE EXCEPTION '������.������� ��������� ������������� � ����� ������ = <%> <%>.'
                                        , vbColor_title
                                        , inTitle
                                         ;
                      END IF;
                      -- 6.2.3. ����� ������������� ����� ����
                      vbGoodsId:= (SELECT Object_Goods.Id
                                   FROM Object AS Object_ProdColor
                                        JOIN ObjectLink AS OL_ProdColor
                                                        ON OL_ProdColor.DescId        = zc_ObjectLink_Goods_ProdColor()
                                                       AND OL_ProdColor.ChildObjectId = Object_ProdColor.Id
                                        JOIN Object AS Object_Goods ON Object_Goods.Id               = OL_ProdColor.ObjectId
                                                                   AND Object_Goods.isErased         = FALSE
                                                                   AND TRIM (Object_Goods.ValueData) ILIKE 'hypalon'
                                   WHERE Object_ProdColor.DescId    = zc_Object_ProdColor()
                                     -- � ����� ������
                                     AND Object_ProdColor.ValueData ILIKE vbColor_title
                                  );

                      -- 6.2.3. ��������
                      IF COALESCE (vbGoodsId, 0) = 0
                      THEN
                          RAISE EXCEPTION '������.�� ������ �������� � ����� ������ = <%> <%>.'
                                        , vbColor_title
                                        , inTitle
                                         ;
                      END IF;

                  END IF;

             END IF;


         ELSE
             -- 6.2.3. ����� ����� � ������
             vbGoodsId:= (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbProdOptionsId  AND OL.DescId = zc_ObjectLink_ProdOptions_Goods());

         END IF;


         -- ���� ��� ������
         IF COALESCE (vbGoodsId, 0) = 0
            -- � ��� Boat Structure
            AND vbProdColorPatternId > 0
         THEN
             -- 6.3. ����� ���� ��� ���������� Boat Structure
             vbComment:= vbColor_title;
             -- 6.3. ��������
             IF COALESCE (TRIM (vbComment), '') = ''
             THEN
                 RAISE EXCEPTION '������.�� ������� �������� ����� ��� ����� = <%>. vbColor_title = <%>'
                                , (SELECT CASE WHEN gpGet.MaterialOptionsName <> '' THEN gpGet.MaterialOptionsName || ' ' ELSE '' END
                                       || lfGet_Object_ValueData (vbProdOptionsId)
                                   FROM gpGet_Object_ProdOptions (inId:=vbProdOptionsId, inProModelId:= NULL, inSession:= inSession) AS gpGet
                                  )
                                , vbColor_title
                                 ;
             END IF;
         END IF;


         -- ��� ���� ���� ���� ���� ��� Comment
         IF (inTitle ILIKE 'light' AND (inTitle3 ILIKE 'color_title' OR inTitle4 ILIKE 'color_title'))
         OR ((inTitle ILIKE 'accessories' OR inTitle ILIKE 'title') AND vbColor_title <> '')
         THEN
             -- 6.3. ����� ���� ��� ���������� �� Boat Structure
             vbComment:= vbColor_title;
             -- 6.3. ��������
             IF COALESCE (TRIM (vbComment), '') = ''
             THEN
                 RAISE EXCEPTION '������.�� ������� �������� ����� ��� ����� = <%>. vbColor_title = <%>'
                                , (SELECT CASE WHEN gpGet.MaterialOptionsName <> '' THEN gpGet.MaterialOptionsName || ' ' ELSE '' END
                                       || lfGet_Object_ValueData (vbProdOptionsId)
                                   FROM gpGet_Object_ProdOptions (inId:=vbProdOptionsId, inProModelId:= NULL, inSession:= inSession) AS gpGet
                                  )
                                , vbColor_title
                                 ;
             END IF;
         END IF;

         -- ��� ���� ���� ���� ��� Comment
         IF (inTitle ILIKE 'accessories' OR inTitle ILIKE 'title') AND inTitle4 ILIKE 'text'
         THEN
             -- 6.3. ����� Name of Boat
             vbComment:= inValue4;
         END IF;

         -- 6.4. �����
         vbProdOptItemsId:= (SELECT Object_ProdOptItems.Id
                             FROM Object AS Object_ProdOptItems
                                  -- �����
                                  INNER JOIN ObjectLink AS ObjectLink_Product
                                                        ON ObjectLink_Product.ObjectId = Object_ProdOptItems.Id
                                                       AND ObjectLink_Product.DescId   = zc_ObjectLink_ProdOptItems_Product()
                                                       AND ObjectLink_Product.ChildObjectId = (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = ioMovementId_OrderClient AND MLO.DescId = zc_MovementLinkObject_Product())
                                  -- �����
                                  INNER JOIN ObjectLink AS ObjectLink_ProdOptions
                                                        ON ObjectLink_ProdOptions.ObjectId = Object_ProdOptItems.Id
                                                       AND ObjectLink_ProdOptions.DescId   = zc_ObjectLink_ProdOptItems_ProdOptions()
                                                       AND ObjectLink_ProdOptions.ChildObjectId IN (SELECT ObjectLink_ProdColorPattern.ObjectId
                                                                                                    FROM ObjectLink AS ObjectLink_ProdColorPattern
                                                                                                    WHERE ObjectLink_ProdColorPattern.DescId = zc_ObjectLink_ProdOptions_ProdColorPattern()
                                                                                                      AND ObjectLink_ProdColorPattern.ChildObjectId
                                                                                                          IN (SELECT ObjectLink_find.ChildObjectId
                                                                                                              FROM ObjectLink AS ObjectLink_find
                                                                                                              WHERE ObjectLink_find.ObjectId = vbProdOptionsId
                                                                                                                AND ObjectLink_find.DescId   = zc_ObjectLink_ProdOptions_ProdColorPattern()
                                                                                                             )
                                                                                                   UNION
                                                                                                    SELECT vbProdOptionsId
                                                                                                   )
                                                                                                    
                                  -- ����� �������
                                  INNER JOIN ObjectFloat AS ObjectFloat_MovementId_OrderClient
                                                         ON ObjectFloat_MovementId_OrderClient.ObjectId  = Object_ProdOptItems.Id
                                                        AND ObjectFloat_MovementId_OrderClient.DescId    = zc_ObjectFloat_ProdOptItems_OrderClient()
                                                        AND ObjectFloat_MovementId_OrderClient.ValueData = ioMovementId_OrderClient
                             WHERE Object_ProdOptItems.DescId   = zc_Object_ProdOptItems()
                               AND Object_ProdOptItems.isErased = FALSE
                            );

/*

    RAISE EXCEPTION '������.
                                                                      vbProdOptItemsId = <%>
                                                                    , inCode                   = <%>
                                                                    , inProductId              = <%>
                                                                    , ioProdOptionsId          = <%>
                                                                    , inProdOptPatternId       = <%>
                                                                    , inProdColorPatternId     = <%>
                                                                    , inMaterialOptionsId      = <%>
                                                                    , inMovementId_OrderClient = <%>
                                                                    , ioGoodsId                = <%>
                                                                    , inAmount                 = <%>
                                                                    , inPriceIn                = <%>
                                                                    , inPriceOut               = <%>
                                                                    , inDiscountTax            = <%>
                                                                    , inPartNumber             = <%>
                                                                    , inComment                = <%>

',
vbProdOptItemsId
, COALESCE ((SELECT Object.ObjectCode  FROM Object WHERE Object.Id = vbProdOptItemsId), 0)
, (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = ioMovementId_OrderClient AND MLO.DescId = zc_MovementLinkObject_Product())
, vbProdOptionsId
, (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbProdOptItemsId AND OL.DescId = zc_ObjectLink_ProdOptItems_ProdOptPattern())
, vbProdColorPatternId
, (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbProdOptionsId  AND OL.DescId = zc_ObjectLink_ProdOptions_MaterialOptions())
, ioMovementId_OrderClient
, vbGoodsId
, 1
, 0
, CASE WHEN inTitle6 ILIKE 'price' THEN zfConvert_StringToFloat (inValue6) ELSE 0 END
, 0
, ''
, vbComment
;
*/
     -- ����
     /*IF inTitle ILIKE 'upholstery' -- AND COALESCE (vbProdOptItemsId, 0) <> 252004
     THEN
          RAISE EXCEPTION '������. <%>  <%>  <%>  <%>  <%>  <%>', vbProdOptItemsId, inTitle, inTitle1, inValue1, inTitle2, inValue2;
     END IF;*/

     -- ����
     /*IF  COALESCE (vbProdOptItemsId, 0)  = 0
     THEN
       RAISE EXCEPTION '������. <%>', inTitle;

     END IF;*/

         -- 6.4. ���������
         vbProdOptItemsId:= (SELECT gpInsertUpdate.ioId
                             FROM gpInsertUpdate_Object_ProdOptItems (ioId                     := vbProdOptItemsId
                                                                    , inCode                   := COALESCE ((SELECT Object.ObjectCode  FROM Object WHERE Object.Id = vbProdOptItemsId), 0)
                                                                    , inProductId              := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = ioMovementId_OrderClient AND MLO.DescId = zc_MovementLinkObject_Product())
                                                                    , ioProdOptionsId          := vbProdOptionsId
                                                                    , inProdOptPatternId       := COALESCE ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbProdOptItemsId AND OL.DescId = zc_ObjectLink_ProdOptItems_ProdOptPattern()), 0)
                                                                    , inProdColorPatternId     := vbProdColorPatternId
                                                                    , inMaterialOptionsId      := (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbProdOptionsId  AND OL.DescId = zc_ObjectLink_ProdOptions_MaterialOptions())
                                                                    , inMovementId_OrderClient := ioMovementId_OrderClient
                                                                    , ioGoodsId                := vbGoodsId
                                                                    , inAmount                 := 1
                                                                    , inPriceIn                := 0
                                                                    , inPriceOut               := CASE WHEN inTitle2 ILIKE 'price' THEN zfConvert_StringToFloat (inValue2)
                                                                                                       WHEN inTitle3 ILIKE 'price' THEN zfConvert_StringToFloat (inValue3)
                                                                                                       WHEN inTitle4 ILIKE 'price' THEN zfConvert_StringToFloat (inValue4)
                                                                                                       WHEN inTitle5 ILIKE 'price' THEN zfConvert_StringToFloat (inValue5)
                                                                                                       WHEN inTitle6 ILIKE 'price' THEN zfConvert_StringToFloat (inValue6)
                                                                                                       ELSE 0
                                                                                                  END
                                                                    , inDiscountTax            := 0
                                                                    , inPartNumber             := ''
                                                                    , inComment                := vbComment
                                                                    , inSession                := inSession
                                                                     ) AS gpInsertUpdate);
     END IF;


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.07.22                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MI_OrderClient_load (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
