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
   DECLARE vbProdColorId        Integer;
   DECLARE vbColor              TVarChar;
   DECLARE vbArticle            Integer;

   DECLARE vbLISSE_MATT TVarChar;

BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpGetUserBySession (inSession);

--if inValue2 ILIKE 'RAL 9001'
--then  inValue2:= 'RAL 9010';
--end if;

-- inValue2:= zfCalc_Text_replace (inValue2, '�', '');


-- if inValue1 = 'b305_u_1' then RAISE EXCEPTION '������.<%>.', inValue1; end if;
-- RAISE EXCEPTION '������.<%   %>.', inValue1,  vbProdOptionsId;


     -- ������ - �����
     inValue2:= zfCalc_Text_replace (inValue2, '&amp;', '&');


     -- ������ - ������ Id_site
     IF inValue1 ILIKE 'b330_doa_' AND inValue2 = 'Dual Battery System' THEN inValue1:= 'b330_doa_3'; END IF;
     IF inValue1 ILIKE 'b330_doa_' AND inValue2 = 'Digital Sonar'       THEN inValue1:= 'b330_doa_4'; END IF;


     -- ������ - ������ Boat Cover + Light Grey ���� Boat Cover + Grey?
     IF inValue2 ILIKE 'Boat Cover' AND inValue4 ILIKE 'Light Grey'
     THEN
         inValue4:= 'Grey';
     END IF;


     -- ������
     IF inValue3 ILIKE 'null' THEN inValue3:= ''; END IF;
     -- ������
     vbLISSE_MATT:= (SELECT Object.ValueData FROM Object WHERE Object.DescId = zc_Object_MaterialOptions()
                                                           AND (Object.ValueData ILIKE 'LISSE\/MATT'
                                                             OR Object.ValueData ILIKE 'LISSE/MATT'
                                                               ));


--     IF inTitle ILIKE 'moldings'
--     THEN
--         RAISE EXCEPTION '������.<%>.', inTitle;
--     END IF;


-- 4871
IF inTitle1 ILIKE 'id' AND SUBSTRING (inValue1 FROM 1  FOR 1) = '_'
   AND NOT EXISTS (SELECT 1
                   FROM Object
                        JOIN ObjectString AS OS ON OS.ObjectId = Object.Id AND OS.DescId = zc_ObjectString_Id_Site()
                                               AND OS.ValueData ILIKE inValue1
                   WHERE Object.DescId    = zc_Object_ProdOptions()
                     AND Object.isErased  = FALSE
                  )
THEN
     inValue1:= COALESCE ((SELECT DISTINCT LEFT (OS.ValueData, 4)
                           FROM Object
                                JOIN ObjectString AS OS ON OS.ObjectId = Object.Id AND OS.DescId = zc_ObjectString_Id_Site()
                                                       AND OS.ValueData <> ''
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
                             AND Object.isErased  = FALSE
                          ), '')
                || inValue1;
END IF;


IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = ioMovementId_OrderClient AND Movement.InvNumber = '5079')
   AND 1=0
THEN
    IF inValue1 = '_hp_c1'
    THEN
        inValue1:= 'b360_hp_c1';
    END IF;

    IF inValue1 = '_hs_c1'
    THEN
        inValue1:= 'b360_hs_c1';
    END IF;

    IF inValue1 = '_m'
    THEN
        inValue1:= 'b360_m_1';
    END IF;

    IF inValue1 = '_u_9'
    THEN
        inValue1:= 'b360_u_9';
    END IF;

    IF inValue1 = '_t_0'
    THEN
        inValue1:= 'b360_t_0';
    END IF;

    IF inValue1 = '_hc'
    THEN
        inValue1:= 'b360_hc';
    END IF;

    IF inValue1 = '_dc'
    THEN
        inValue1:= 'b360_dc';
    END IF;

    IF inValue1 = '_sc'
    THEN
        inValue1:= 'b360_sc';
    END IF;

    IF inValue1 = '_doa_0'
    THEN
        inValue1:= 'b360_doa_0';
    END IF;

    IF inValue1 = '_doa_1'
    THEN
        inValue1:= 'b360_doa_1';
    END IF;

    IF inValue1 = '_doa_2'
    THEN
        inValue1:= 'b360_doa_2';
    END IF;

    IF inValue1 = '_doa_3'
    THEN
        inValue1:= 'b360_doa_3';
    END IF;

    IF inValue1 = '_loa_0'
    THEN
        inValue1:= 'b360_loa_0';
    END IF;

    IF inValue1 = '_loa_1'
    THEN
        inValue1:= 'b360_loa_1';
    END IF;

    IF inValue1 = '_aoa_0'
    THEN
        inValue1:= 'b360_aoa_0';
    END IF;

    IF inValue1 = '_aoa_3'
    THEN
        inValue1:= 'b360_aoa_3';
    END IF;

END IF;


     -- ������ - �������� - �����������
     IF inTitle ILIKE 'upholstery' AND inTitle2 ILIKE 'material_title' AND inValue2 ILIKE 'LIENZO' AND inValue3 ILIKE 'Black'
        AND 1=0
     THEN inValue2:= 'SILVERTEX�';
          IF inValue1 = 'b280_u_3' THEN inValue1:= 'b280_u_1'; END IF;

     -- ������ - �������� - �����������
     ELSEIF inTitle ILIKE 'upholstery' AND inValue1 <> 'b280_u_1' AND inTitle2 ILIKE 'material_title' AND inValue2 ILIKE 'SILVERTEX�'
        AND 1=0
     THEN inValue1 = 'b280_u_1';
          -- ������ - �������� - �����������
          IF inValue3 ILIKE 'Ice Cream' AND inValue5 ILIKE 'NAU-5002'
          THEN inValue5 = '122-2090';
          END IF;

     -- ������ - �������� - �����������
     ELSEIF inTitle ILIKE 'teak' AND inValue1 <> 'b280_t_2' AND inTitle2 ILIKE 'material_title' AND inValue2 ILIKE 'BLEACHED'
        AND 1=0
     THEN inValue1 = 'b280_t_2';


--     ELSEIF inTitle ILIKE 'hypalon_secondary' AND inValue1 ILIKE 'b280_hs_b'
--     THEN inValue1:= 'b280_hs_c0';
--     ELSEIF inTitle ILIKE 'moldings' AND inValue1 ILIKE 'b280_m'
--     THEN inValue1:= 'b280_m_1';
--     ELSEIF inTitle ILIKE 'upholstery' AND inValue1 ILIKE 'b280_u_' AND inValue2 ILIKE 'DIAMANTE'
--     THEN inValue1:= 'b280_u_4';

     --ELSEIF inTitle ILIKE 'upholstery' AND inTitle2 ILIKE 'material_title' AND inValue2 ILIKE 'DIAMANTE'
     --THEN inValue1:= 'b280_u_4';

     END IF;

     -- ������ - �������� - �����������
     IF inValue1 ILIKE 'b280_loa_'
     THEN
         IF inValue2 ILIKE 'LED Deck Lights 3x'    THEN inValue1:= 'b280_loa_0'; END IF;
         IF inValue2 ILIKE 'OceanLED X4 x2'        THEN inValue1:= 'b280_loa_1'; END IF;
         IF inValue2 ILIKE 'LED Navigation Lights' THEN inValue1:= 'b280_loa_2'; END IF;
     END IF;
     -- ������ - �������� - �����������
     IF inValue1 ILIKE 'b280_aoa_'
     THEN
         IF inValue2 ILIKE 'Removable Steering wheel'               THEN inValue1:= 'b280_aoa_1'; END IF;
         IF inValue2 ILIKE 'Anti-Theft Security System (D.E.S.S.)'  THEN inValue1:= 'b280_aoa_2'; END IF;
         IF inValue2 ILIKE 'Ladder'                                 THEN inValue1:= 'b280_aoa_3'; END IF;
         IF inValue2 ILIKE 'Name of Boat'                           THEN inValue1:= 'b280_aoa_6'; END IF;
     END IF;
     -- ������ - �������� - �����������
     IF inValue1 ILIKE 'b280_aoav__'
     THEN
         IF TRIM (inValue4) ILIKE '3 x Flush fitting padeyes c\/w tie down starps and fixings' THEN inValue1:= 'b280_aoav_8_0'; END IF;
     END IF;


     -- ������ - Schwarz=black ��� order=6393
     IF inTitle ILIKE 'moldings' AND inTitle2 ILIKE 'color_title' AND inValue2 ILIKE TRIM ('Schwarz')
     THEN
         inValue2:= 'Black';
     END IF;
 
     -- ������ ������ ������
     IF TRIM (inValue4) ILIKE '%3 x Flush fitting padeyes c/w tie down starps and fixings' AND inValue1 <> ''
        AND 1 = (SELECT COUNT(*)
                 FROM Object
                      JOIN ObjectString AS OS ON OS.ObjectId = Object.Id AND OS.DescId = zc_ObjectString_Id_Site() AND OS.ValueData = inValue1
                 WHERE Object.DescId = zc_Object_ProdOptions() AND Object.isErased = FALSE
                )
     THEN -- 160 = ascii('�3 x Flush fitting padeyes c/w tie down starps and fixings')
          inValue4:= (SELECT Object.ValueData
                      FROM Object
                           JOIN ObjectString AS OS ON OS.ObjectId = Object.Id AND OS.DescId = zc_ObjectString_Id_Site() AND OS.ValueData = inValue1
                      WHERE Object.DescId = zc_Object_ProdOptions() AND Object.isErased = FALSE
                      ORDER BY Object.Id
                     );
     END IF;


     --***IF inValue1 = 'b280_t_4' AND inValue2 ILIKE 'SCRUBBED' THEN inValue1:= 'b280_t_1'; END IF;
     --***IF inValue1 = 'b280_t_4' AND inValue2 ILIKE 'BLEACHED' THEN inValue1:= 'b280_t_2'; END IF;



     -- ������
     IF (inTitle ILIKE 'hypalon_primary' OR inTitle ILIKE 'hypalon_secondary' OR inTitle ILIKE 'moldings' OR inTitle ILIKE 'upholstery' OR inTitle ILIKE 'teak' )
     THEN
         -- ���� ��������
         IF inValue2 ILIKE 'Basic' AND inTitle ILIKE 'moldings' THEN inValue2:= 'NEPTUNE GREY'; END IF;
         -- ���� ��������
         IF inValue2 ILIKE 'Basic' AND (inTitle ILIKE 'hypalon_primary' OR inTitle ILIKE 'hypalon_secondary') THEN inValue2:= ''; END IF;
         -- ���� ������
         IF inValue2 ILIKE 'Grey Light' AND inTitle ILIKE 'moldings' THEN inValue2:= 'Light Grey'; END IF;
         --
         -- ���� � ���� ������
         IF NOT EXISTS (SELECT 1 FROM Object JOIN ObjectString AS OS ON OS.ObjectId = Object.Id AND OS.DescId = zc_ObjectString_Id_Site() AND OS.ValueData = inValue1 WHERE Object.DescId = zc_Object_ProdOptions())
         THEN
             -- ���������
             inValue12:= inValue1;
             -- ������
             IF inValue2 = '' AND (inTitle ILIKE 'hypalon_primary' OR inTitle ILIKE 'hypalon_secondary')
             THEN
                 -- ������ 1 ������
                 inValue1:= SUBSTRING (inValue1 FROM 1 FOR LENGTH (inValue1) - 1) || 'c0';

             ELSEIF inTitle ILIKE 'moldings'
             THEN
                 -- ��������� 2 �������
                 inValue1:= inValue1 || '_1';

             ELSEIF inTitle ILIKE 'teak'
             THEN
                 -- ������ 1 ������
                 inValue1:= SUBSTRING (inValue1 FROM 1 FOR LENGTH (inValue1) - 1) || '9';

             ELSE
                 -- ������ 1 ������
                 IF SUBSTRING (inValue1 FROM LENGTH (inValue1) FOR 1) = '_'
                 THEN inValue1:= inValue1 || '0'; --!!!��������
                 ELSE inValue1:= SUBSTRING (inValue1 FROM 1 FOR LENGTH (inValue1) - 1) || '0';
                 END IF;
             END IF;

             -- �������� - ����� ����
             IF NOT EXISTS (SELECT 1 FROM Object JOIN ObjectString AS OS ON OS.ObjectId = Object.Id AND OS.DescId = zc_ObjectString_Id_Site() AND OS.ValueData = inValue1 WHERE Object.DescId = zc_Object_ProdOptions())
             THEN
                 RAISE EXCEPTION '������.�� ������� ����� � Key = <%> + �������� = <%>. ����� ������ ����� <%>'
                                , inValue1
                                , inTitle
                                , inValue12
                                 ;
             END IF;

         END IF;

     END IF;



     -- ������ - ��������
     IF (inTitle ILIKE 'upholstery' OR inTitle ILIKE 'teak')
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

        --***
        AND 1=0
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
             RAISE EXCEPTION '������-1.������ ��� <%>. <%> + <%> + <%> �� �������', inValue12, inTitle, inValue2, inValue4;
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
        --***
        AND 1=0
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
             RAISE EXCEPTION '������-2.������ ��� <%>. <%> + <%> + <%> �� �������', inValue12, inTitle, inValue2, inValue4;
         END IF;

     ELSEIF (inTitle ILIKE 'light' OR inTitle ILIKE 'accessories' OR inTitle ILIKE 'title')
        -- ���� ��� ������ Id_Site + Name
        AND NOT EXISTS (SELECT 1 FROM Object JOIN ObjectString AS OS ON OS.ObjectId = Object.Id AND OS.DescId = zc_ObjectString_Id_Site() AND OS.ValueData = inValue1 WHERE Object.DescId = zc_Object_ProdOptions() AND TRIM (Object.ValueData) ILIKE TRIM (inValue2) AND Object.isErased = FALSE)
        --***
        AND 1=0
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
             RAISE EXCEPTION '������-3.������ ��� <%>. <%> + <%> + <%> �� ������� <%>', inValue12, inTitle, inValue2, inValue4
             , (SELECT Object.ValueData FROM Object JOIN ObjectString AS OS ON OS.ObjectId = Object.Id AND OS.DescId = zc_ObjectString_Id_Site() AND OS.ValueData = inValue12 WHERE Object.DescId = zc_Object_ProdOptions() AND Object.isErased = FALSE)
             ;
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

         -- ��������� �������� <NPP>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_NPP(), ioMovementId_OrderClient
                                             , 1 + COALESCE ((SELECT MAX (COALESCE (MovementFloat.ValueData, 0))
                                                              FROM MovementFloat
                                                                   INNER JOIN Movement ON Movement.Id     = MovementFloat.MovementId
                                                                                      AND Movement.DescId = zc_Movement_OrderClient()
                                                                                      AND Movement.StatusId <> zc_Enum_Status_Erased()
                                                              WHERE MovementFloat.DescId = zc_MovementFloat_NPP()
                                                             ), 0));

         -- ��������� �������� <���� ��������>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioMovementId_OrderClient, CURRENT_TIMESTAMP);
         -- ��������� �������� <������������ (��������)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioMovementId_OrderClient, vbUserId);

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


     -- 4. ������ - !!!�� ���������!!!
     IF inTitle ILIKE 'client' AND 1=0
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
             -- �����-1: Name + Phone-1
             vbClientId:= (SELECT OS.ObjectId FROM ObjectString AS OS JOIN Object ON Object.Id = OS.ObjectId AND TRIM (Object.ValueData) ILIKE TRIM (inValue1) WHERE OS.ValueData ILIKE inValue2 AND OS.DescId = zc_ObjectString_Client_Phone());

             -- ���� �� �����
             IF COALESCE (vbClientId, 0) = 0
             THEN
                 -- ��������-2
                 IF 1 < (SELECT COUNT(*) FROM ObjectString AS OS JOIN Object ON Object.Id = OS.ObjectId AND TRIM (Object.ValueData) ILIKE TRIM (inValue1) WHERE OS.ValueData ILIKE inValue2 AND OS.DescId = zc_ObjectString_Client_Mobile())
                 THEN
                     RAISE EXCEPTION '������.� �������� = <%> ������ � ������ ��������.', inValue2;
                 END IF;
                 -- �����-2: Name + Phone-2
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

             -- �����: Name + Email
             vbClientId:= (SELECT OS.ObjectId FROM ObjectString AS OS JOIN Object ON Object.Id = OS.ObjectId AND TRIM (Object.ValueData) ILIKE TRIM (inValue1) WHERE OS.ValueData ILIKE inValue3 AND OS.DescId = zc_ObjectString_Client_Email());

         END IF;

         -- ����� �� Name
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
         ioProductId:= (SELECT tmp.ioId
                        FROM gpInsertUpdate_Object_Product
                                               (ioId                    := ioProductId
                                              , inCode                  := COALESCE ((SELECT Object.ObjectCode FROM Object WHERE Object.Id = ioProductId), lfGet_ObjectCode(0, zc_Object_Product()))
                                              , inName                  := (SELECT Object.ValueData  FROM Object WHERE Object.Id = ioProductId)
                                              , inBrandId               := (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbModelId AND OL.DescId = zc_ObjectLink_ProdModel_Brand())
                                              , inModelId               := vbModelId
                                              , inEngineId              := (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbModelId AND OL.DescId = zc_ObjectLink_ProdModel_ProdEngine())
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
                                              , inClientId              := -1 -- (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.DescId = zc_MovementLinkObject_From() AND MLO.MovementId = ioMovementId_OrderClient)
                                              , inIsBasicConf           := -- �������� ������� ������������
                                                                           COALESCE ((SELECT OB.ValueData FROM ObjectBoolean AS OB WHERE OB.DescId = zc_ObjectBoolean_Product_BasicConf() AND OB.ObjectId = ioProductId)
                                                                                   , TRUE)
                                              , inIsReserve             := --��������������� ����� � ������������ �������������
                                                                           COALESCE ((SELECT OB.ValueData FROM ObjectBoolean AS OB WHERE OB.DescId = zc_ObjectBoolean_Product_Reserve() AND OB.ObjectId = ioProductId)
                                                                                   , FALSE)
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
                                              , inDiscountTax           := COALESCE ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = ioMovementId_OrderClient AND MF.DescId = zc_MovementFloat_DiscountTax()), 0)
                                              , inDiscountNextTax       := COALESCE ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = ioMovementId_OrderClient AND MF.DescId = zc_MovementFloat_DiscountNextTax()), 0)
                                              , ioSummTax               := COALESCE ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = ioMovementId_OrderClient AND MF.DescId = zc_MovementFloat_SummTax()), 0)
                                              , ioSummReal              := COALESCE ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = ioMovementId_OrderClient AND MF.DescId = zc_MovementFloat_SummReal()), 0)
                                              , inTransportSumm_load    := COALESCE ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = ioMovementId_OrderClient AND MF.DescId = zc_MovementFloat_TransportSumm_load()), 0)
                                              , inDateStart             := NULL
                                              , inDateBegin             := COALESCE ((SELECT OD.ValueData FROM ObjectDate AS OD WHERE OD.DescId = zc_ObjectDate_Product_DateBegin() AND OD.ObjectId = ioProductId), CURRENT_DATE + INTERVAL '3 MONTH')
                                              , inDateSale              := NULL
                                              , inCIN                   := COALESCE ((SELECT OS.ValueData FROM ObjectString AS OS WHERE OS.DescId = zc_ObjectString_Product_CIN() AND OS.ObjectId = ioProductId), '-')
                                              , inEngineNum             := COALESCE ((SELECT OS.ValueData FROM ObjectString AS OS WHERE OS.DescId = zc_ObjectString_Product_EngineNum() AND OS.ObjectId = ioProductId), '')
                                              , inComment               := COALESCE ((SELECT OS.ValueData FROM ObjectString AS OS WHERE OS.DescId = zc_ObjectString_Product_Comment() AND OS.ObjectId = ioProductId), '')

                                              , inMovementId_OrderClient:= ioMovementId_OrderClient
                                              , inInvNumber_OrderClient := (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = ioMovementId_OrderClient)
                                              , inOperDate_OrderClient  := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = ioMovementId_OrderClient)
                                              , inNPP_OrderClient       := COALESCE ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = ioMovementId_OrderClient AND MF.DescId = zc_MovementFloat_NPP()), 0)

                                              /*, inMovementId_Invoice    := (SELECT MLM.MovementChildId FROM MovementLinkMovement AS MLM WHERE MLM.DescId = zc_MovementLinkMovement_Invoice() AND MLM.MovementId = ioMovementId_OrderClient)
                                              , inInvNumber_Invoice     := ''
                                              , inOperDate_Invoice      := (SELECT Movement.OperDate FROM MovementLinkMovement AS MLM JOIN Movement ON Movement.Id = MLM.MovementChildId WHERE MLM.DescId = zc_MovementLinkMovement_Invoice() AND MLM.MovementId = ioMovementId_OrderClient)
                                              , inAmountIn_Invoice      := 0
                                              , inAmountOut_Invoice     := 0*/

                                              , inSession               := inSession
                                               ) AS tmp
                       );

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
         ioMovementId_OrderClient:= (SELECT tmp.ioId
                                     FROM lpInsertUpdate_Movement_OrderClient (ioId                 := ioMovementId_OrderClient
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
                                                                             , ioSummTax            := COALESCE ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = ioMovementId_OrderClient AND MF.DescId = zc_MovementFloat_SummTax()), 0)
                                                                             , ioSummReal           := COALESCE ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = ioMovementId_OrderClient AND MF.DescId = zc_MovementFloat_SummReal()), 0)
                                                                             , inTransportSumm_load := COALESCE ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = ioMovementId_OrderClient AND MF.DescId = zc_MovementFloat_TransportSumm_load()), 0)
                                                                             , inFromId             := -1 -- (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.DescId = zc_MovementLinkObject_From() AND MLO.MovementId = ioMovementId_OrderClient)
                                                                             , inToId               := COALESCE ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.DescId = zc_MovementLinkObject_To() AND MLO.MovementId = ioMovementId_OrderClient), zc_Unit_Production())
                                                                             , inPaidKindId         := COALESCE ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.DescId = zc_MovementLinkObject_PaidKind() AND MLO.MovementId = ioMovementId_OrderClient), zc_Enum_PaidKind_FirstForm())
                                                                             , inProductId          := ioProductId
                                                                             , inMovementId_Invoice := (SELECT MLM.MovementChildId FROM MovementLinkMovement AS MLM WHERE MLM.DescId = zc_MovementLinkMovement_Invoice() AND MLM.MovementId = ioMovementId_OrderClient)
                                                                             , inComment            := COALESCE ((SELECT MS.ValueData FROM MovementString AS MS WHERE MS.DescId = zc_MovementString_Comment() AND MS.MovementId = ioMovementId_OrderClient), '1')
                                                                             , inUserId             := vbUserId
                                                                              ) AS tmp
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
         -- 6.0.1. ����� ����
         vbColor_title:= CASE WHEN inTitle2 ILIKE 'color_title' THEN inValue2
                              WHEN inTitle3 ILIKE 'color_title' THEN inValue3
                              WHEN inTitle4 ILIKE 'color_title' THEN inValue4
                              WHEN inTitle5 ILIKE 'color_title' THEN inValue5
                              WHEN inTitle6 ILIKE 'color_title' THEN inValue6
                              WHEN inTitle7 ILIKE 'color_title' THEN inValue7
                         END;
         -- 6.0.2 ����� ���� - ��������
         vbColor:= CASE WHEN inTitle2 ILIKE 'color' THEN inValue2
                        WHEN inTitle3 ILIKE 'color' THEN inValue3
                        WHEN inTitle4 ILIKE 'color' THEN inValue4
                        WHEN inTitle5 ILIKE 'color' THEN inValue5
                        WHEN inTitle6 ILIKE 'color' THEN inValue6
                        WHEN inTitle7 ILIKE 'color' THEN inValue7
                   END;

         -- 6.1. ����� ProdOptions
         IF inTitle1 ILIKE 'id' AND TRIM (inValue1) <> ''
         THEN
             -- ���� ���� ���� + ��������� Id_Site
             IF vbColor_title <> '' AND 1 < (SELECT COUNT(*) FROM Object JOIN ObjectString AS OS ON OS.ObjectId = Object.Id AND OS.DescId = zc_ObjectString_Id_Site() AND OS.ValueData = inValue1 WHERE Object.DescId = zc_Object_ProdOptions() AND Object.isErased = FALSE)
             THEN
                 -- ����� �� Id_Site + color
                 vbProdOptionsId:= (SELECT Object.Id
                                    FROM Object
                                         JOIN ObjectString AS OS ON OS.ObjectId = Object.Id AND OS.DescId = zc_ObjectString_Id_Site() AND OS.ValueData = inValue1
                                         JOIN ObjectLink AS OL
                                                         ON OL.ObjectId = Object.Id
                                                        AND OL.DescId   = zc_ObjectLink_ProdOptions_Goods()
                                         JOIN ObjectLink AS OL_ProdColor
                                                         ON OL_ProdColor.ObjectId = OL.ChildObjectId
                                                        AND OL_ProdColor.DescId   = zc_ObjectLink_Goods_ProdColor()
                                         JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = OL_ProdColor.ChildObjectId
                                                                        -- ��� �� ����
                                                                        AND Object_ProdColor.ValueData ILIKE vbColor_title
                                    WHERE Object.DescId   = zc_Object_ProdOptions()
                                      AND Object.isErased = FALSE
                                   );
             ELSE
                 -- ����� �� Id_Site
                 vbProdOptionsId:= (SELECT Object.Id
                                    FROM Object
                                         JOIN ObjectString AS OS ON OS.ObjectId = Object.Id AND OS.DescId = zc_ObjectString_Id_Site() AND OS.ValueData = inValue1
                                    WHERE Object.DescId = zc_Object_ProdOptions() AND Object.isErased = FALSE
                                      -- !!!�������� ������ Id_Site ����������!!!
                                      AND (Object.ValueData ILIKE CASE WHEN inTitle4 ILIKE 'variant_title' THEN TRIM (inValue4) ELSE TRIM (inValue2) END
                                        OR SUBSTRING (inValue1 FROM LENGTH(inValue1) FOR 1) <> '_'
                                          )
                                    ORDER BY Object.Id
                                    LIMIT CASE WHEN SUBSTRING (inValue1 FROM LENGTH(inValue1) FOR 1) = '_' THEN 2 ELSE 1 END
                                   );
             END IF;

         END IF;

         -- 6.1. ��������
         IF COALESCE (vbProdOptionsId, 0) = 0
         THEN
             RAISE EXCEPTION '������.�� ������� �������� ����� � Key = <%> + ���� = <%>.', inValue1, vbColor_title;
         END IF;
         -- 6.1. �������� - category_title+inValue2 ������ ��������������� MaterialOptionsId
         IF (inTitle ILIKE 'hypalon_primary' OR inTitle ILIKE 'hypalon_secondary')
            AND NOT EXISTS (SELECT 1 FROM ObjectLink AS OL JOIN Object ON Object.Id = OL.ChildObjectId AND Object.ValueData ILIKE CASE WHEN COALESCE (inValue2, '') = '' THEN vbLISSE_MATT ELSE inValue2 END AND Object.isErased = FALSE WHERE OL.ObjectId = vbProdOptionsId  AND OL.DescId = zc_ObjectLink_ProdOptions_MaterialOptions())
            -- !!!���� MaterialOptions �� ������!!!
          --AND COALESCE (inValue2, '') <> ''
         THEN
             --***
             -- ���������
             /*inValue12:= vbProdOptionsId :: TVarChar;
             -- !!!�������� ������, �.�. ������ MaterialOptions!!!
             vbProdOptionsId:= COALESCE ((SELECT OL.ObjectId
                                          FROM ObjectLink AS OL
                                               -- ������ MaterialOptions
                                               JOIN Object AS Object_MaterialOptions ON Object_MaterialOptions.Id        = OL.ChildObjectId
                                                                                    -- ����� ������ ��������
                                                                                    AND Object_MaterialOptions.ValueData ILIKE CASE WHEN COALESCE (inValue2, '') = '' THEN vbLISSE_MATT ELSE inValue2 END
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
                 RAISE EXCEPTION '������.�� ������� ����� � Key = <%> + MaterialOptions = <%>. ����� ������ ��� <%>(<%>)', inValue1, CASE WHEN COALESCE (inValue2, '') = '' THEN vbLISSE_MATT ELSE inValue2 END, lfGet_Object_ValueData (inValue12 :: Integer), inValue12;
             END IF;*/

             RAISE EXCEPTION '������.��� <%><%> ��������� ����� ������ ���� = <%> � �������� ����������� = <%>.'
                            , inValue1, lfGet_Object_ValueData_sh (vbProdOptionsId)
                            , lfGet_Object_ValueData_sh ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbProdOptionsId  AND OL.DescId = zc_ObjectLink_ProdOptions_MaterialOptions()))
                            , inValue2
                             ;
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
            AND NOT EXISTS (SELECT 1 FROM Object WHERE Object.Id = vbProdOptionsId AND Object.ValueData ILIKE CASE WHEN inTitle4 ILIKE 'variant_title' THEN TRIM (inValue4) ELSE TRIM (inValue2) END AND Object.isErased = FALSE)
            -- !!!�������� ������ Id_Site ����������!!!
            AND SUBSTRING (inValue1 FROM LENGTH(inValue1) FOR 1) <> '_'
         THEN
             --***
             -- !!!�������� ������, �.�. ������ Name!!!
             /*vbProdOptionsId:= COALESCE ((SELECT Object.Id
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
             END IF;*/

             RAISE EXCEPTION '������.��� <%> ������� ����� ������ ���� = <%> � �������� ����������� = <%>.'
                            , inValue1, lfGet_Object_ValueData_sh (vbProdOptionsId)
                            , CASE WHEN inTitle4 ILIKE 'variant_title' THEN TRIM (inValue4) ELSE TRIM (inValue2) END
                             ;
         END IF;


         -- 6.2.1. ����� Boat Structure
         vbProdColorPatternId:= (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbProdOptionsId AND OL.DescId = zc_ObjectLink_ProdOptions_ProdColorPattern());

         -- 6.2.2.
         IF vbColor_title <> ''
         THEN
             -- �����
             vbProdColorId:= COALESCE ((SELECT MIN (Object.Id) FROM Object WHERE Object.DescId = zc_Object_ProdColor() AND Object.ValueData ILIKE vbColor_title AND Object.isErased = FALSE)
                                     , (SELECT MIN (Object.Id) FROM Object WHERE Object.DescId = zc_Object_ProdColor() AND Object.ValueData ILIKE vbColor_title AND Object.isErased = TRUE)
                                      );
             -- �������
             IF COALESCE (vbProdColorId, 0) = 0
             THEN vbProdColorId:= (SELECT gpInsertUpdate.ioId
                                   FROM gpInsertUpdate_Object_ProdColor (ioId     := 0
                                                                       , ioCode   := 0
                                                                       , inName   := vbColor_title
                                                                       , inComment:= ''
                                                                       , inValue  := vbColor
                                                                       , inSession:= inSession
                                                                        ) AS gpInsertUpdate);
             ELSEIF vbColor <> ''
             THEN
                 -- �������� �������� ����� ���� �� ����
                 PERFORM lpUpdate_Object_ProdColor_Value (inId     := Object.Id
                                                        , inValue  := vbColor
                                                        , inUserId := vbUserId
                                                         )
                 FROM Object
                 WHERE Object.DescId = zc_Object_ProdColor()
                   AND Object.ValueData ILIKE vbColor_title
                ;

             END IF;

         END IF;


         -- 6.2.3. �����
         IF vbProdColorPatternId > 0
            AND (inTitle ILIKE 'hypalon_primary'
              OR inTitle ILIKE 'hypalon_secondary'
              OR inTitle ILIKE 'moldings'
              OR inTitle ILIKE 'upholstery'
              OR inTitle ILIKE 'hull'
              OR inTitle ILIKE 'deck'
              OR inTitle ILIKE 'sconsole'
                )
         THEN
             -- 0.1. ���� ���� ����� �� ��� � ������ � �����
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
            -- ��� "������", �.�. � ���� �� Article
            AND inTitle NOT ILIKE 'upholstery'

             THEN
                  -- 0.2. ����� � ������ ��� Boat Structure
                  vbGoodsId:= (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbProdOptionsId AND OL.DescId = zc_ObjectLink_ProdOptions_Goods());

             -- ����� ����� ������
             ELSE
                  IF inTitle ILIKE 'hypalon_primary' OR inTitle ILIKE 'hypalon_secondary'
                  THEN
                      -- 1.1. �������� - � �������� Object_Goods ���� 'hypalon'
                      IF 1 < (SELECT COUNT(*)
                              FROM ObjectLink AS OL_ProdColor
                                   JOIN Object AS Object_Goods ON Object_Goods.Id               = OL_ProdColor.ObjectId
                                                              AND Object_Goods.isErased         = FALSE
                                                              AND TRIM (Object_Goods.ValueData) ILIKE 'hypalon'
                              WHERE OL_ProdColor.DescId        = zc_ObjectLink_Goods_ProdColor()
                                -- � ����� ������
                                AND OL_ProdColor.ChildObjectId IN (SELECT vbProdColorId UNION SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_ProdColor() AND Object.ValueData ILIKE vbColor_title AND Object.isErased = FALSE)
                             )
                      THEN
                          RAISE EXCEPTION '������.������� ��������� % � ����� ������ = <%>.'
                                        , inTitle
                                        , vbColor_title
                                         ;
                      END IF;
                      -- 1.2. ����� Hypalon ����� ����
                      vbGoodsId:= COALESCE ((SELECT Object_Goods.Id
                                             FROM ObjectLink AS OL_ProdColor
                                                  JOIN Object AS Object_Goods ON Object_Goods.Id               = OL_ProdColor.ObjectId
                                                                             AND Object_Goods.isErased         = FALSE
                                                                             AND TRIM (Object_Goods.ValueData) ILIKE 'hypalon'
                                             WHERE OL_ProdColor.DescId        = zc_ObjectLink_Goods_ProdColor()
                                               -- � ����� ������
                                               AND OL_ProdColor.ChildObjectId IN (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_ProdColor() AND Object.ValueData ILIKE vbColor_title AND Object.isErased = FALSE)
                                            )
                                          , (SELECT Object_Goods.Id
                                             FROM ObjectLink AS OL_ProdColor
                                                  JOIN Object AS Object_Goods ON Object_Goods.Id               = OL_ProdColor.ObjectId
                                                                             AND Object_Goods.isErased         = FALSE
                                                                             AND TRIM (Object_Goods.ValueData) ILIKE 'hypalon'
                                             WHERE OL_ProdColor.DescId        = zc_ObjectLink_Goods_ProdColor()
                                               -- � ����� ������
                                               AND OL_ProdColor.ChildObjectId IN (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_ProdColor() AND Object.ValueData ILIKE vbColor_title AND Object.isErased = TRUE)
                                           ));

                      -- 1.3. �������
                      IF COALESCE (vbGoodsId, 0) = 0
                      THEN
                          -- ���������
                          vbArticle:= 1 + (SELECT MAX (zfConvert_StringToNumber (SUBSTRING (OS_Article.ValueData, 4, 255)))
                                           FROM Object
                                                JOIN ObjectString AS OS_Article
                                                                  ON OS_Article.ObjectId = Object.Id
                                                                 AND OS_Article.DescId   = zc_ObjectString_Article()
                                           WHERE Object.DescId = zc_Object_Goods() AND Object.ValueData ILIKE 'hypalon'
                                          );
                          -- ���� ����� ��� ����
                          IF EXISTS (SELECT 1
                                     FROM Object
                                          JOIN ObjectString AS OS_Article
                                                            ON OS_Article.ObjectId  = Object.Id
                                                           AND OS_Article.DescId    = zc_ObjectString_Article()
                                                           AND OS_Article.ValueData ILIKE ('AGL' || REPEAT ('0', 6 - LENGTH (vbArticle :: TVarChar)) || vbArticle :: TVarChar)
                                     WHERE Object.DescId = zc_Object_Goods()
                                    )
                          THEN
                              -- "�����" ��������
                              vbArticle:= 101 + (SELECT MAX (zfConvert_StringToNumber (SUBSTRING (OS_Article.ValueData, 4, 255)))
                                                 FROM Object
                                                      JOIN ObjectString AS OS_Article
                                                                        ON OS_Article.ObjectId = Object.Id
                                                                       AND OS_Article.DescId   = zc_ObjectString_Article()
                                                 WHERE Object.DescId = zc_Object_Goods() AND Object.ValueData ILIKE 'hypalon'
                                                );
                          END IF;
                          --
                          vbGoodsId:= gpInsertUpdate_Object_Goods
                                                 (ioId                     := 0
                                                , inCode                   := -1
                                                , inName                   := 'Hypalon'
                                                , inArticle                := 'AGL' || REPEAT ('0', 7 - LENGTH (vbArticle :: TVarChar)) || vbArticle :: TVarChar
                                                , inArticleVergl           := ''
                                                , inEAN                    := ''
                                                , inASIN                   := ''
                                                , inMatchCode              := ''
                                                , inFeeNumber              := ''
                                                , inComment                := ''
                                                , inIsArc                  := FALSE
                                                , inFeet                   := 0
                                                , inMetres                 := 0
                                                , inAmountMin              := 0
                                                , inAmountRefer            := 0
                                                , inEKPrice                := 0
                                                , inEmpfPrice              := 0
                                                , inGoodsGroupId           := 2864 -- Hypalon
                                                , inMeasureId              := 2761 --- ��
                                                , inGoodsTagId             := NULL
                                                , inGoodsTypeId            := NULL
                                                , inGoodsSizeId            := NULL
                                                , inProdColorId            := vbProdColorId
                                                , inPartnerId              := 2975 -- ORCA
                                                , inUnitId                 := NULL
                                                , inDiscountPartnerId      := NULL
                                                , inTaxKindId              := zc_Enum_TaxKind_Basis()
                                                , inEngineId               := NULL
                                                , inPriceListId      := Null     ::Integer
                                                , inStartDate_price  := Null     ::TDateTime 
                                                , inOperPriceList    := 0        :: TFloat
                                                , inSession                := inSession
                                                 );
                      END IF;

                      -- 1.4. �������� - ���� ������
                      IF COALESCE (vbGoodsId, 0) = 0
                      THEN
                          RAISE EXCEPTION '������.�� ������ <%> � ����� ������ = <%>.'
                                        , inTitle
                                        , vbColor_title
                                         ;
                      END IF;

                  -- ������ ��� �������
                  ELSEIF inTitle ILIKE 'upholstery'
                  THEN
                      -- 2.1. ����� ������������� ����� Article + ���� + ������������ GoodsName = MaterialOptions
                      vbGoodsId:= COALESCE ((SELECT Object_Goods.Id
                                             FROM ObjectLink AS OL_ProdColor
                                                  JOIN Object AS Object_Goods ON Object_Goods.Id       = OL_ProdColor.ObjectId
                                                                             AND Object_Goods.isErased = FALSE
                                                                             -- GoodsName = MaterialOptions
                                                                             --***AND CASE WHEN inTitle2 ILIKE 'material_title' THEN inValue2
                                                                             --***         WHEN inTitle3 ILIKE 'material_title' THEN inValue3
                                                                             --***  --END ILIKE (TRIM (Object_Goods.ValueData))
                                                                             --***    END ILIKE (TRIM (Object_Goods.ValueData) || '%')
                                                  JOIN ObjectString AS ObjectString_Article
                                                                    ON ObjectString_Article.ObjectId = OL_ProdColor.ObjectId
                                                                   AND ObjectString_Article.DescId   = zc_ObjectString_Article()
                                                                   AND ObjectString_Article.ValueData ILIKE CASE WHEN inTitle5 ILIKE 'code' THEN inValue5
                                                                                                                 WHEN inTitle6 ILIKE 'code' THEN inValue6
                                                                                                                 WHEN inTitle7 ILIKE 'code' THEN inValue7
                                                                                                            END
                                             WHERE OL_ProdColor.DescId        = zc_ObjectLink_Goods_ProdColor()
                                               -- � ����� ������
                                               AND OL_ProdColor.ChildObjectId IN (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_ProdColor() AND Object.ValueData ILIKE vbColor_title AND Object.isErased = FALSE)
                                            )
                                          , (SELECT Object_Goods.Id
                                             FROM ObjectLink AS OL_ProdColor
                                                  JOIN Object AS Object_Goods ON Object_Goods.Id       = OL_ProdColor.ObjectId
                                                                             AND Object_Goods.isErased = FALSE
                                                                             -- GoodsName = MaterialOptions
                                                                             --***AND CASE WHEN inTitle2 ILIKE 'material_title' THEN inValue2
                                                                             --***         WHEN inTitle3 ILIKE 'material_title' THEN inValue3
                                                                             --***  --END ILIKE (TRIM (Object_Goods.ValueData))
                                                                             --***    END ILIKE (TRIM (Object_Goods.ValueData) || '%')
                                                  JOIN ObjectString AS ObjectString_Article
                                                                    ON ObjectString_Article.ObjectId = OL_ProdColor.ObjectId
                                                                   AND ObjectString_Article.DescId   = zc_ObjectString_Article()
                                                                   AND ObjectString_Article.ValueData ILIKE CASE WHEN inTitle5 ILIKE 'code' THEN inValue5
                                                                                                                 WHEN inTitle6 ILIKE 'code' THEN inValue6
                                                                                                                 WHEN inTitle7 ILIKE 'code' THEN inValue7
                                                                                                            END
                                             WHERE OL_ProdColor.DescId        = zc_ObjectLink_Goods_ProdColor()
                                               -- � ����� ������
                                               AND OL_ProdColor.ChildObjectId IN (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_ProdColor() AND Object.ValueData ILIKE vbColor_title AND Object.isErased = TRUE)
                                           ));

                      -- 2.2. �������
                      IF COALESCE (vbGoodsId, 0) = 0
                      THEN
                          /*RAISE EXCEPTION '������.<%>.', CASE WHEN inTitle5 ILIKE 'code' THEN inValue5
                                                              WHEN inTitle6 ILIKE 'code' THEN inValue6
                                                              WHEN inTitle7 ILIKE 'code' THEN inValue7
                                                         END;*/

                          -- ���� ������� ���� �� ���� �� ����������
                          IF 1 = (SELECT COUNT(*)
                                  FROM Object AS Object_Goods 
                                       JOIN ObjectString AS ObjectString_Article
                                                         ON ObjectString_Article.ObjectId = Object_Goods.Id
                                                        AND ObjectString_Article.DescId   = zc_ObjectString_Article()
                                                        AND ObjectString_Article.ValueData ILIKE CASE WHEN inTitle5 ILIKE 'code' THEN inValue5
                                                                                                      WHEN inTitle6 ILIKE 'code' THEN inValue6
                                                                                                      WHEN inTitle7 ILIKE 'code' THEN inValue7
                                                                                                 END
                                       LEFT JOIN ObjectLink AS OL_ProdColor
                                                            ON OL_ProdColor.ObjectId = Object_Goods.Id
                                                           AND OL_ProdColor.DescId   = zc_ObjectLink_Goods_ProdColor()
                                                           -- � ����� ������
                                                           -- AND OL_ProdColor.ChildObjectId IN (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_ProdColor() AND Object.ValueData ILIKE vbColor_title AND Object.isErased = FALSE)
                                  WHERE Object_Goods.DescId   = zc_Object_Goods()
                                    AND Object_Goods.isErased = FALSE
                                    -- ������ ����
                                    AND OL_ProdColor.ChildObjectId IS NULL
                                 )
                          THEN
                              -- ����� ������������� ����� Article
                              vbGoodsId:= (SELECT Object_Goods.Id
                                           FROM Object AS Object_Goods 
                                                JOIN ObjectString AS ObjectString_Article
                                                                  ON ObjectString_Article.ObjectId = Object_Goods.Id
                                                                 AND ObjectString_Article.DescId   = zc_ObjectString_Article()
                                                                 AND ObjectString_Article.ValueData ILIKE CASE WHEN inTitle5 ILIKE 'code' THEN inValue5
                                                                                                               WHEN inTitle6 ILIKE 'code' THEN inValue6
                                                                                                               WHEN inTitle7 ILIKE 'code' THEN inValue7
                                                                                                          END
                                                LEFT JOIN ObjectLink AS OL_ProdColor
                                                                     ON OL_ProdColor.ObjectId = Object_Goods.Id
                                                                    AND OL_ProdColor.DescId   = zc_ObjectLink_Goods_ProdColor()
                                                                    -- � ����� ������
                                                                    -- AND OL_ProdColor.ChildObjectId IN (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_ProdColor() AND Object.ValueData ILIKE vbColor_title AND Object.isErased = FALSE)
                                           WHERE Object_Goods.DescId   = zc_Object_Goods()
                                             AND Object_Goods.isErased = FALSE
                                             -- ������ ����
                                             AND OL_ProdColor.ChildObjectId IS NULL
                                          );

                              --
                              IF NOT EXISTS (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_ProdColor() AND Object.ValueData ILIKE vbColor_title AND Object.isErased = FALSE)
                              THEN 
                                  RAISE EXCEPTION '������.�� ������� �������� ����� = <%> ���������� ������� ��� �������� � ����������.', vbColor_title;
                              ELSE
                                  -- ���������� ����
                                  PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_ProdColor(), vbGoodsId, (SELECT MIN (Object.Id) FROM Object WHERE Object.DescId = zc_Object_ProdColor() AND Object.ValueData ILIKE vbColor_title AND Object.isErased = FALSE));

                              END IF;

                          ELSE
                              -- �������
                              vbGoodsId:= gpInsertUpdate_Object_Goods
                                                     (ioId                     := 0
                                                    , inCode                   := -1
                                                    , inName                   := -- MaterialOptions = BELUGA
                                                                                  CASE WHEN inTitle2 ILIKE 'material_title' THEN inValue2
                                                                                       WHEN inTitle3 ILIKE 'material_title' THEN inValue3
                                                                                  END
                                                    , inArticle                := -- Article = BEL-3302
                                                                                  CASE WHEN inTitle5 ILIKE 'code' THEN inValue5
                                                                                       WHEN inTitle6 ILIKE 'code' THEN inValue6
                                                                                       WHEN inTitle7 ILIKE 'code' THEN inValue7
                                                                                  END
                                                    , inArticleVergl           := ''
                                                    , inEAN                    := ''
                                                    , inASIN                   := ''
                                                    , inMatchCode              := ''
                                                    , inFeeNumber              := ''
                                                    , inComment                := ''
                                                    , inIsArc                  := FALSE
                                                    , inFeet                   := 0
                                                    , inMetres                 := 0
                                                    , inAmountMin              := 0
                                                    , inAmountRefer            := 0
                                                    , inEKPrice                := 0
                                                    , inEmpfPrice              := 0
                                                    , inGoodsGroupId           := 2865 -- Fabric
                                                    , inMeasureId              := 2761 --- ��
                                                    , inGoodsTagId             := NULL
                                                    , inGoodsTypeId            := NULL
                                                    , inGoodsSizeId            := NULL
                                                    , inProdColorId            := vbProdColorId -- Pure white
                                                    , inPartnerId              := NULL
                                                    , inUnitId                 := NULL
                                                    , inDiscountPartnerId      := NULL
                                                    , inTaxKindId              := zc_Enum_TaxKind_Basis()
                                                    , inEngineId               := NULL
                                                    , inPriceListId      := Null     ::Integer
                                                    , inStartDate_price  := Null     ::TDateTime 
                                                    , inOperPriceList    := 0        :: TFloat
                                                    , inSession                := inSession
                                                     );
                          END IF;
                      END IF;

                      -- 2.3. �������� - ���� ������
                      IF COALESCE (vbGoodsId, 0) = 0
                      THEN
                          RAISE EXCEPTION '������.�� ������� �������� Article = <%> � ���� = <%> ��� �������������� = <%>.'
                                         , CASE WHEN inTitle5 ILIKE 'code' THEN inValue5
                                                WHEN inTitle6 ILIKE 'code' THEN inValue6
                                                WHEN inTitle7 ILIKE 'code' THEN inValue7
                                           END
                                         , vbColor_title
                                         , CASE WHEN inTitle2 ILIKE 'material_title' THEN inValue2
                                                WHEN inTitle3 ILIKE 'material_title' THEN inValue3
                                           END
                                          ;
                      END IF;

                  -- moldings + ������ + ������ + ������� �������� ����������
                  ElSEIF inTitle ILIKE 'hull' OR inTitle ILIKE 'deck' OR inTitle ILIKE 'sconsole' OR inTitle ILIKE 'moldings'
                  THEN
                      -- 2.1.1. �������� - ���� ���� ���� � ������ ����
                      IF 1 = (SELECT COUNT(*)
                              FROM
                                   (SELECT DISTINCT Object_Goods.Id
                                    FROM ObjectLink AS OL_ProdColor
                                         JOIN Object AS Object_Goods ON Object_Goods.Id        = OL_ProdColor.ObjectId
                                                                    AND Object_Goods.isErased  = FALSE
                                                                    AND TRIM (Object_Goods.ValueData) ILIKE CASE WHEN inTitle ILIKE 'moldings' THEN 'fender' ELSE TRIM (Object_Goods.ValueData) END
                                         -- ����� ����� � ������
                                         INNER JOIN ObjectLink AS ObjectLink_Object
                                                               ON ObjectLink_Object.ChildObjectId = Object_Goods.Id
                                                              AND ObjectLink_Object.DescId        = zc_ObjectLink_ReceiptGoodsChild_Object()
                                         -- ������� ������ �� ������
                                         INNER JOIN Object AS Object_ReceiptGoodsChild ON Object_ReceiptGoodsChild.Id       = ObjectLink_Object.ObjectId
                                                                                      AND Object_ReceiptGoodsChild.isErased = FALSE
                                         -- ������ �� �������
                                         LEFT JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                                              ON ObjectLink_ReceiptGoods.ObjectId = Object_ReceiptGoodsChild.Id
                                                             AND ObjectLink_ReceiptGoods.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                                         INNER JOIN Object AS Object_ReceiptGoods ON Object_ReceiptGoods.Id       = ObjectLink_ReceiptGoods.ChildObjectId
                                                                                 AND Object_ReceiptGoods.isErased = FALSE
                                         -- ����� ������
                                         LEFT JOIN ObjectLink AS ObjectLink_ColorPattern
                                                              ON ObjectLink_ColorPattern.ObjectId = Object_ReceiptGoods.Id
                                                             AND ObjectLink_ColorPattern.DescId   = zc_ObjectLink_ReceiptGoods_ColorPattern()
                                         INNER JOIN ObjectLink AS ObjectLink_Model
                                                               ON ObjectLink_Model.ObjectId      = ObjectLink_ColorPattern.ChildObjectId
                                                              AND ObjectLink_Model.DescId        = zc_ObjectLink_ColorPattern_Model()
                                         -- !!! ������ ������������ ��� ��� ���������
                                         INNER JOIN ObjectLink AS ObjectLink_Product_Model
                                                               ON ObjectLink_Product_Model.ObjectId      = ioProductId
                                                              AND ObjectLink_Product_Model.DescId        = zc_ObjectLink_Product_Model()
                                                              AND ObjectLink_Product_Model.ChildObjectId = ObjectLink_Model.ChildObjectId
                                         -- ����� ��� ����
                                         LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                              ON ObjectLink_Goods.ObjectId = Object_ReceiptGoods.Id
                                                             AND ObjectLink_Goods.DescId   = zc_ObjectLink_ReceiptGoods_Object()
                                         INNER JOIN Object AS Object_Goods_master ON Object_Goods_master.Id  = ObjectLink_Goods.ChildObjectId
                                         -- � ����� ���� ����� �� inTitle
                                         INNER JOIN ObjectString AS OS_Comment
                                                                 ON OS_Comment.ObjectId = Object_Goods_master.Id
                                                                AND OS_Comment.DescId   = zc_ObjectString_Goods_Comment()
                                                                AND OS_Comment.ValueData ILIKE CASE WHEN inTitle ILIKE 'sconsole' THEN 'STEERING CONSOLE' ELSE '%' || inTitle || '%' END
      
                                    WHERE OL_ProdColor.DescId        = zc_ObjectLink_Goods_ProdColor()
                                      -- � ����� ������
                                      AND OL_ProdColor.ChildObjectId IN (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_ProdColor() AND Object.ValueData ILIKE vbColor_title AND Object.isErased = FALSE)
                                   ) AS tmp
                             )
                             AND 1=1
                      THEN
                          -- 2.2.2. ����� ������������� ����� ���� + ������ ������
                          vbGoodsId:=
                                   (SELECT DISTINCT Object_Goods.Id
                                    FROM ObjectLink AS OL_ProdColor
                                         JOIN Object AS Object_Goods ON Object_Goods.Id        = OL_ProdColor.ObjectId
                                                                    AND Object_Goods.isErased  = FALSE
                                                                    AND TRIM (Object_Goods.ValueData) ILIKE CASE WHEN inTitle ILIKE 'moldings' THEN 'fender' ELSE TRIM (Object_Goods.ValueData) END
                                         -- ����� ����� � ������
                                         INNER JOIN ObjectLink AS ObjectLink_Object
                                                               ON ObjectLink_Object.ChildObjectId = Object_Goods.Id
                                                              AND ObjectLink_Object.DescId        = zc_ObjectLink_ReceiptGoodsChild_Object()
                                         -- ������� ������ �� ������
                                         INNER JOIN Object AS Object_ReceiptGoodsChild ON Object_ReceiptGoodsChild.Id       = ObjectLink_Object.ObjectId
                                                                                      AND Object_ReceiptGoodsChild.isErased = FALSE
                                         -- ������ �� �������
                                         LEFT JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                                              ON ObjectLink_ReceiptGoods.ObjectId = Object_ReceiptGoodsChild.Id
                                                             AND ObjectLink_ReceiptGoods.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                                         INNER JOIN Object AS Object_ReceiptGoods ON Object_ReceiptGoods.Id       = ObjectLink_ReceiptGoods.ChildObjectId
                                                                                 AND Object_ReceiptGoods.isErased = FALSE
                                         -- ����� ������
                                         LEFT JOIN ObjectLink AS ObjectLink_ColorPattern
                                                              ON ObjectLink_ColorPattern.ObjectId = Object_ReceiptGoods.Id
                                                             AND ObjectLink_ColorPattern.DescId   = zc_ObjectLink_ReceiptGoods_ColorPattern()
                                         INNER JOIN ObjectLink AS ObjectLink_Model
                                                               ON ObjectLink_Model.ObjectId      = ObjectLink_ColorPattern.ChildObjectId
                                                              AND ObjectLink_Model.DescId        = zc_ObjectLink_ColorPattern_Model()
                                         -- !!! ������ ������������ ��� ��� ���������
                                         INNER JOIN ObjectLink AS ObjectLink_Product_Model
                                                               ON ObjectLink_Product_Model.ObjectId      = ioProductId
                                                              AND ObjectLink_Product_Model.DescId        = zc_ObjectLink_Product_Model()
                                                              AND ObjectLink_Product_Model.ChildObjectId = ObjectLink_Model.ChildObjectId
                                         -- ����� ��� ����
                                         LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                              ON ObjectLink_Goods.ObjectId = Object_ReceiptGoods.Id
                                                             AND ObjectLink_Goods.DescId   = zc_ObjectLink_ReceiptGoods_Object()
                                         INNER JOIN Object AS Object_Goods_master ON Object_Goods_master.Id  = ObjectLink_Goods.ChildObjectId
                                         -- � ����� ���� ����� �� inTitle
                                         INNER JOIN ObjectString AS OS_Comment
                                                                 ON OS_Comment.ObjectId = Object_Goods_master.Id
                                                                AND OS_Comment.DescId   = zc_ObjectString_Goods_Comment()
                                                                AND OS_Comment.ValueData ILIKE CASE WHEN inTitle ILIKE 'sconsole' THEN 'STEERING CONSOLE' ELSE '%' || inTitle || '%' END
      
                                    WHERE OL_ProdColor.DescId        = zc_ObjectLink_Goods_ProdColor()
                                      -- � ����� ������
                                      AND OL_ProdColor.ChildObjectId IN (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_ProdColor() AND Object.ValueData ILIKE vbColor_title AND Object.isErased = FALSE)
                                   );

                      -- 2.1.2. ��������
                      ELSEIF 1 < (SELECT COUNT(*)
                              FROM ObjectLink AS OL_ProdColor
                                   JOIN Object AS Object_Goods ON Object_Goods.Id        = OL_ProdColor.ObjectId
                                                              AND Object_Goods.isErased  = FALSE
                                                              AND TRIM (Object_Goods.ValueData) ILIKE CASE WHEN inTitle ILIKE 'moldings' THEN 'fender' ELSE TRIM (Object_Goods.ValueData) END
                                                            /*AND Object_Goods.ObjectCode BETWEEN CASE WHEN inTitle ILIKE 'hull' OR inTitle ILIKE 'deck' OR inTitle ILIKE 'sconsole'
                                                                                                       THEN -100
                                                                                                       ELSE Object_Goods.ObjectCode
                                                                                                  END
                                                                                              AND CASE WHEN inTitle ILIKE 'hull' OR inTitle ILIKE 'deck' OR inTitle ILIKE 'sconsole'
                                                                                                       THEN 1
                                                                                                       ELSE Object_Goods.ObjectCode
                                                                                                  END*/
                                   LEFT JOIN ObjectString AS OS_Comment
                                                          ON OS_Comment.ObjectId = Object_Goods.Id
                                                         AND OS_Comment.DescId   = zc_ObjectString_Goods_Comment()
                                                         AND (OS_Comment.ValueData ILIKE 'HULL/DECK'
                                                           OR OS_Comment.ValueData ILIKE 'HULL'
                                                           OR OS_Comment.ValueData ILIKE 'DECK'
                                                           OR OS_Comment.ValueData ILIKE 'STEERING CONSOLE'
                                                             )

                              WHERE OL_ProdColor.DescId        = zc_ObjectLink_Goods_ProdColor()
                                -- � ����� ������
                                AND OL_ProdColor.ChildObjectId IN (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_ProdColor() AND Object.ValueData ILIKE vbColor_title AND Object.isErased = FALSE)
                                -- "����" � ����� ���������� ���������
                                AND OS_Comment.ObjectId IS NULL
                             )
                      THEN
                          RAISE EXCEPTION '������.������� ��������� ����� �����%��� <%>%� ������ = <%>.' -- %<%>
                                        , CHR (13)
                                        , inTitle
                                        , CHR (13)
                                        , vbColor_title
                                       -- , CHR (13)
                                       -- , vbProdColorId
                                         ;
                      ELSE
                          -- 2.2.2. ����� ������������� ����� ����
                          vbGoodsId:= COALESCE ((SELECT Object_Goods.Id
                                                 FROM ObjectLink AS OL_ProdColor
                                                      JOIN Object AS Object_Goods ON Object_Goods.Id        = OL_ProdColor.ObjectId
                                                                                 AND Object_Goods.isErased  = FALSE
                                                                                 AND TRIM (Object_Goods.ValueData) ILIKE CASE WHEN inTitle ILIKE 'moldings' THEN 'fender' ELSE TRIM (Object_Goods.ValueData) END
                                                                               /*AND Object_Goods.ObjectCode BETWEEN CASE WHEN inTitle ILIKE 'hull' OR inTitle ILIKE 'deck' OR inTitle ILIKE 'sconsole'
                                                                                                                          THEN -100
                                                                                                                          ELSE Object_Goods.ObjectCode
                                                                                                                     END
                                                                                                                 AND CASE WHEN inTitle ILIKE 'hull' OR inTitle ILIKE 'deck' OR inTitle ILIKE 'sconsole'
                                                                                                                          THEN 1
                                                                                                                          ELSE Object_Goods.ObjectCode
                                                                                                                     END*/
                                                      LEFT JOIN ObjectString AS OS_Comment
                                                                             ON OS_Comment.ObjectId = Object_Goods.Id
                                                                            AND OS_Comment.DescId   = zc_ObjectString_Goods_Comment()
                                                                            AND (OS_Comment.ValueData ILIKE 'HULL/DECK'
                                                                              OR OS_Comment.ValueData ILIKE 'HULL'
                                                                              OR OS_Comment.ValueData ILIKE 'DECK'
                                                                              OR OS_Comment.ValueData ILIKE 'STEERING CONSOLE'
                                                                                )

                                                 WHERE OL_ProdColor.DescId        = zc_ObjectLink_Goods_ProdColor()
                                                   -- � ����� ������
                                                   AND OL_ProdColor.ChildObjectId IN (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_ProdColor() AND Object.ValueData ILIKE vbColor_title AND Object.isErased = FALSE)
                                                   -- "����" � ����� ���������� ���������
                                                   AND OS_Comment.ObjectId IS NULL
                                                )
                                              , (SELECT Object_Goods.Id
                                                 FROM ObjectLink AS OL_ProdColor
                                                      JOIN Object AS Object_Goods ON Object_Goods.Id       = OL_ProdColor.ObjectId
                                                                                 AND Object_Goods.isErased  = FALSE
                                                                                 AND TRIM (Object_Goods.ValueData) ILIKE CASE WHEN inTitle ILIKE 'moldings' THEN 'fender' ELSE TRIM (Object_Goods.ValueData) END
                                                 WHERE OL_ProdColor.DescId        = zc_ObjectLink_Goods_ProdColor()
                                                   -- � ����� ������
                                                   AND OL_ProdColor.ChildObjectId IN (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_ProdColor() AND Object.ValueData ILIKE vbColor_title AND Object.isErased = TRUE)
                                               ));
                      END IF;

                      -- 2.3. ������� RAL...
                      IF COALESCE (vbGoodsId, 0) = 0 AND vbColor_title ILIKE '%RAL%' AND (inTitle ILIKE 'hull' OR inTitle ILIKE 'deck' OR inTitle ILIKE 'sconsole')
                      AND 1=1
                      THEN
                          -- ���� �� ������ zc_Object_ProdColor
                          IF NOT EXISTS (SELECT 1 FROM Object WHERE Object.DescId = zc_Object_ProdColor() AND Object.ValueData ILIKE vbColor_title AND Object.isErased = FALSE)
                          THEN
                              RAISE EXCEPTION '������.�� ������ ���� = <%> (%).', vbColor_title, vbProdColorId;
                              -- ������� zc_Object_ProdColor
                              vbProdColorId:= (SELECT gpInsertUpdate.ioId
                                               FROM gpInsertUpdate_Object_ProdColor (ioId     := 0
                                                                                   , ioCode   := 0
                                                                                   , inName   := vbColor_title
                                                                                   , inComment:= ''
                                                                                   , inValue  := vbColor
                                                                                   , inSession:= inSession
                                                                                    ));
                          END IF;

                          -- �������
                          vbGoodsId:= gpInsertUpdate_Object_Goods
                                                 (ioId                     := 0
                                                , inCode                   := 0
                                                , inName                   := vbColor_title
                                                , inArticle                := vbColor_title
                                                , inArticleVergl           := ''
                                                , inEAN                    := ''
                                                , inASIN                   := ''
                                                , inMatchCode              := ''
                                                , inFeeNumber              := ''
                                                , inComment                := 'Korpus'
                                                , inIsArc                  := FALSE
                                                , inFeet                   := 0
                                                , inMetres                 := 0
                                                , inAmountMin              := 0
                                                , inAmountRefer            := 0
                                                , inEKPrice                := 0
                                                , inEmpfPrice              := 0
                                                , inGoodsGroupId           := 2651  -- Boote
                                                , inMeasureId              := 34898 -- ��
                                                , inGoodsTagId             := NULL
                                                , inGoodsTypeId            := NULL
                                                , inGoodsSizeId            := NULL
                                                , inProdColorId            := vbProdColorId -- RAL...
                                                , inPartnerId              := NULL
                                                , inUnitId                 := NULL
                                                , inDiscountPartnerId      := NULL
                                                , inTaxKindId              := zc_Enum_TaxKind_Basis()
                                                , inEngineId               := NULL
                                                , inPriceListId      := Null     ::Integer
                                                , inStartDate_price  := Null     ::TDateTime 
                                                , inOperPriceList    := 0        :: TFloat
                                                , inSession                := inSession
                                                 );

                      END IF;

                      -- 2.4. ��������
                      IF COALESCE (vbGoodsId, 0) = 0
                      THEN
                          RAISE EXCEPTION '������.�� ������� ����� ��� <%> � ������ = <%>.���������� ��� �������� ������� ��� <%> ��� <%>.%�������� ������ ��� ���� � <%> �� <%>.'
                                        , inTitle
                                        , vbColor_title
                                        , lfGet_Object_ValueData (252217), lfGet_Object_ValueData (6357)
                                        , CHR (13)
                                        , -100
                                        , 1
                                         ;
                      END IF;

                  END IF;

             END IF;


         ELSE
             -- 6.2.3. ����� ����� ��� �����
             vbGoodsId:= (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbProdOptionsId  AND OL.DescId = zc_ObjectLink_ProdOptions_Goods());

         END IF;


         -- ���� ��� ������
         IF COALESCE (vbGoodsId, 0) = 0
            -- � ��� Boat Structure
            AND vbProdColorPatternId > 0
         THEN
             -- ��������
             IF EXISTS (SELECT 1 FROM ObjectLink AS OL WHERE OL.ObjectId = vbProdColorPatternId AND OL.DescId = zc_ObjectLink_ProdColorPattern_Goods() AND OL.ChildObjectId > 0)
             THEN
                 RAISE EXCEPTION '������.�� ������� ������������� = <%> � ����� ������ = <%>.'
                                , lfGet_Object_ValueData_sh((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbProdColorPatternId AND OL.DescId = zc_ObjectLink_ProdColorPattern_Goods()))
                                , vbColor_title
                                 ;
             END IF;

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

         -- ������ ���� ���������� �� "����"
         IF NOT EXISTS (SELECT 1
                        FROM gpSelect_Object_ProdColorItems (inMovementId_OrderClient:= ioMovementId_OrderClient, inIsShowAll:= TRUE, inIsErased:= FALSE, inIsSale:= FALSE, inSession:= inSession
                                                            ) AS gpSelect
                        WHERE -- ����� �������������
                              COALESCE (gpSelect.GoodsId_Receipt, 0) = COALESCE (vbGoodsId, 0)
                          -- ��������� �����
                          AND COALESCE (gpSelect.MaterialOptionsId_Receipt, 0) = COALESCE ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbProdOptionsId AND OL.DescId = zc_ObjectLink_ProdOptions_MaterialOptions()), 0)
                          -- ���� ����� ����������
                          AND CASE WHEN COALESCE (gpSelect.GoodsId_Receipt, 0) > 0 THEN '' ELSE COALESCE (gpSelect.Comment, '') END = COALESCE (vbComment, '')
                          -- Boat Structure
                          AND gpSelect.ProdColorPatternId = vbProdColorPatternId
                          -- ���� ��� Boat Structure
                          AND vbProdColorPatternId > 0
                          -- ���� ����� ��� �� �����������
                          AND COALESCE (vbProdOptItemsId, 0) = 0
                       )

         THEN
             -- 6.4. ���������
             vbProdOptItemsId:= (SELECT gpInsertUpdate.ioId
                                 FROM gpInsertUpdate_Object_ProdOptItems (ioId                     := vbProdOptItemsId
                                                                        , inCode                   := COALESCE ((SELECT Object.ObjectCode  FROM Object WHERE Object.Id = vbProdOptItemsId), 0)
                                                                        , inProductId              := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = ioMovementId_OrderClient AND MLO.DescId = zc_MovementLinkObject_Product())
                                                                        , ioProdOptionsId          := vbProdOptionsId
                                                                        , inProdOptPatternId       := COALESCE ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbProdOptItemsId AND OL.DescId = zc_ObjectLink_ProdOptItems_ProdOptPattern()), 0)
                                                                        , inProdColorPatternId     := vbProdColorPatternId
                                                                        , inMaterialOptionsId      := -- �������� ��� ����� vbProdOptionsId
                                                                                                      (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbProdOptionsId AND OL.DescId = zc_ObjectLink_ProdOptions_MaterialOptions())
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
                                                                        , inCommentOpt             := ''
                                                                        , inIsEnabled              := TRUE
                                                                        , inSession                := inSession
                                                                         ) AS gpInsertUpdate);
         END IF;

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
