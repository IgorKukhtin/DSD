-- Function: gpInsertUpdate_MovementItem_Income_Load ()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income_Load (Integer, Integer, TVarChar, TDateTime, Integer, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TDateTime, TVarChar, TDateTime
                                                               , Boolean, TFloat, TVarChar, TVarChar, TVarChar,TVarChar, TVarChar, TDateTime, TDateTime, Boolean, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income_Load (Integer, Integer, TVarChar, TDateTime, Integer, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TDateTime, TVarChar, TDateTime
                                                               , Boolean, TFloat, TVarChar, TVarChar, TVarChar,TVarChar, TVarChar, TDateTime, TDateTime, Boolean, TVarChar);
                                                               
CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Income_Load(
    IN inJuridicalId_from    Integer   , -- ����������� ���� - ���������
    IN inJuridicalId_to      Integer   , -- ����������� ���� - "����"
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    
    IN inCommonCode          Integer   , -- ID ������� (�������� ������)
    IN inBarCode             TVarChar  , 
    IN inGoodsCode           TVarChar  , -- ID ������
    IN inGoodsName           TVarChar  , -- ������������ ������
    IN inAmount              TFloat    , -- ���������� 
    IN inPrice               TFloat    , -- ���� ��������� (��� ������ ��� ����������) 
    IN inExpirationDate      TDateTime , -- ���� ��������
    IN inPartitionGoods      TVarChar  , -- ����� �����   
    IN inPaymentDate         TDateTime , -- ���� ������
    IN inPriceWithVAT        Boolean   , -- �������: ���� �������� ��� ��� �� ���.���
    IN inVAT                 TFloat    , -- ������� ���
    IN inUnitName            TVarChar  , 
    IN inMakerName           TVarChar  , -- ������������ �������������
    IN inFEA                 TVarChar  , -- �� ���
    IN inMeasure             TVarChar  , -- ��. ���������
    IN inSertificatNumber    TVarChar  , -- ����� �����������
    IN inSertificatStart     TDateTime , -- ���� ������ �����������
    IN inSertificatEnd       TDateTime , -- ���� ��������� �����������
    IN inisLastRecord        Boolean   ,
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;

   DECLARE vbMovementId Integer;
   DECLARE vbStatusId Integer;

   DECLARE vbMovementItemId Integer;
   DECLARE vbPartnerGoodsId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbNDSKindId Integer;
   DECLARE vbContractId Integer;

   DECLARE vbAreaId_find Integer;
BEGIN
     -- ������������ <������������>
     vbUserId := lpGetUserBySession (inSession);

     --�������� ��������
     CREATE TEMP TABLE _tmpContract (ContractId Integer, Deferment Integer) ON COMMIT DROP;
          INSERT INTO _tmpContract (ContractId, Deferment)
               SELECT ObjectLink_Contract_Juridical.ObjectId     AS ContractId
                    , ObjectFloat_Deferment.ValueData ::Integer  AS Deferment
               FROM ObjectLink AS ObjectLink_Contract_Juridical
                  LEFT JOIN ObjectFloat AS ObjectFloat_Deferment 
                                        ON ObjectFloat_Deferment.ObjectId = ObjectLink_Contract_Juridical.ObjectId
                                       AND ObjectFloat_Deferment.DescId = zc_ObjectFloat_Contract_Deferment()
              WHERE ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                AND ObjectLink_Contract_Juridical.ChildObjectId = inJuridicalId_from;

         -- ���� ������������� � �������. ��� � �����
         SELECT tmp.ContractId, tmp.UnitId
                INTO vbContractId, vbUnitId
         FROM (WITH tmpList AS (SELECT ObjectLink_ObjectChild.ChildObjectId            AS ContractId -- ����� �������
                                     , ObjectLink_ObjectMain.ChildObjectId                                   AS UnitId
                                     , LOWER (TRIM (Object_ImportExportLink.ValueData)) :: TVarChar          AS StringKey
                                     , LOWER (zfCalc_Word_Split (Object_ImportExportLink.ValueData, '%', 1)) AS StringKey1
                                     , LOWER (zfCalc_Word_Split (Object_ImportExportLink.ValueData, '%', 2)) AS StringKey2
                                     , LOWER (zfCalc_Word_Split (Object_ImportExportLink.ValueData, '%', 3)) AS StringKey3
                                FROM _tmpContract
                                     INNER JOIN ObjectLink AS ObjectLink_ObjectChild
                                             ON ObjectLink_ObjectChild.ChildObjectId =  _tmpContract.ContractId               --ObjectLink_ObjectChild.ObjectId = Object_ImportExportLink.Id
                                            AND ObjectLink_ObjectChild.DescId = zc_ObjectLink_ImportExportLink_ObjectChild()

                                     LEFT JOIN Object AS Object_ImportExportLink
                                            ON Object_ImportExportLink.Id = ObjectLink_ObjectChild.ObjectId
                                           AND Object_ImportExportLink.DescId = zc_Object_ImportExportLink()

                                     LEFT JOIN ObjectLink AS ObjectLink_ObjectMain
                                            ON ObjectLink_ObjectMain.ObjectId = ObjectLink_ObjectChild.ObjectId
                                           AND ObjectLink_ObjectMain.DescId = zc_ObjectLink_ImportExportLink_ObjectMain()

                                     LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                            ON ObjectLink_Unit_Juridical.ObjectId = ObjectLink_ObjectMain.ChildObjectId -- Object_ImportExportLink_View.MainId
                                           AND ObjectLink_Unit_Juridical.DescId   = zc_ObjectLink_Unit_Juridical()
                                WHERE (ObjectLink_Unit_Juridical.ChildObjectId = inJuridicalId_to OR COALESCE (inJuridicalId_to, 0) = 0)
                               )
               -- ����� ���������
               SELECT tmpList.ContractId, tmpList.UnitId
               FROM tmpList
               WHERE (LOWER (inUnitName) = StringKey AND StringKey  <> '' AND StringKey1 = '' AND StringKey2 = '' AND StringKey3 = ''
                     )
                  OR (LOWER (inUnitName) LIKE '%' || StringKey1 || '%' AND StringKey1 <> '' AND StringKey2 = '' AND StringKey3 = ''
                      )
                  OR (LOWER (inUnitName) LIKE '%' || StringKey1 || '%'
                  AND LOWER (inUnitName) LIKE '%' || StringKey2 || '%' AND StringKey1 <> '' AND StringKey2 <> '' AND StringKey3 = ''
                     )
                  OR (LOWER (inUnitName) LIKE '%' || StringKey1 || '%'
                  AND LOWER (inUnitName) LIKE '%' || StringKey2 || '%'
                  AND LOWER (inUnitName) LIKE '%' || StringKey3 || '%' AND StringKey1 <> '' AND StringKey2 <> '' AND StringKey3 <> ''
                     )
              ) AS tmp;


     -- ���� �� ����� - ���� ������������� �� ������, � ��� ������� - ����� �����...
     IF COALESCE (vbUnitId, 0) = 0
     THEN

         SELECT tmp.UnitId
                INTO vbUnitId
         FROM (WITH tmpList AS (SELECT ObjectLink_ObjectChild.ChildObjectId AS JuridicalId
                                     , ObjectLink_ObjectMain.ChildObjectId  AS UnitId
                                     , LOWER (TRIM (Object_ImportExportLink.ValueData)) :: TVarChar          AS StringKey
                                     , LOWER (zfCalc_Word_Split (Object_ImportExportLink.ValueData, '%', 1)) AS StringKey1
                                     , LOWER (zfCalc_Word_Split (Object_ImportExportLink.ValueData, '%', 2)) AS StringKey2
                                     , LOWER (zfCalc_Word_Split (Object_ImportExportLink.ValueData, '%', 3)) AS StringKey3
                                FROM Object AS Object_ImportExportLink
                                    INNER JOIN ObjectLink AS ObjectLink_ObjectChild
                                            ON ObjectLink_ObjectChild.ObjectId = Object_ImportExportLink.Id
                                           AND ObjectLink_ObjectChild.DescId = zc_ObjectLink_ImportExportLink_ObjectChild()
                                           AND ObjectLink_ObjectChild.ChildObjectId = inJuridicalId_from
 
                                    LEFT JOIN ObjectLink AS ObjectLink_ObjectMain
                                           ON ObjectLink_ObjectMain.ObjectId = Object_ImportExportLink.Id
                                          AND ObjectLink_ObjectMain.DescId = zc_ObjectLink_ImportExportLink_ObjectMain()
       
                                    LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                           ON ObjectLink_Unit_Juridical.ObjectId = ObjectLink_ObjectMain.ChildObjectId -- Object_ImportExportLink_View.MainId
                                          AND ObjectLink_Unit_Juridical.DescId   = zc_ObjectLink_Unit_Juridical()
                                WHERE Object_ImportExportLink.DescId = zc_Object_ImportExportLink()
                                  AND (ObjectLink_Unit_Juridical.ChildObjectId = inJuridicalId_to OR COALESCE (inJuridicalId_to, 0) = 0)
                               )
               -- ����� ���������
               SELECT tmpList.JuridicalId, tmpList.UnitId
               FROM tmpList
               WHERE (LOWER (inUnitName) = StringKey AND StringKey  <> '' AND StringKey1 = '' AND StringKey2 = '' AND StringKey3 = ''
                     )
                  OR (LOWER (inUnitName) LIKE '%' || StringKey1 || '%' AND StringKey1 <> '' AND StringKey2 = '' AND StringKey3 = ''
                     )
                  OR (LOWER (inUnitName) LIKE '%' || StringKey1 || '%'
                  AND LOWER (inUnitName) LIKE '%' || StringKey2 || '%' AND StringKey1 <> '' AND StringKey2 <> '' AND StringKey3 = ''
                     )
                  OR (LOWER (inUnitName) LIKE '%' || StringKey1 || '%'
                  AND LOWER (inUnitName) LIKE '%' || StringKey2 || '%'
                  AND LOWER (inUnitName) LIKE '%' || StringKey3 || '%' AND StringKey1 <> '' AND StringKey2 <> '' AND StringKey3 <> ''
                     )
              ) AS tmp;

    END IF;


    -- ���� �� �����, �� ����� ��������. !!!������������� ������ ����!!!
    IF COALESCE (vbUnitId, 0) = 0
    THEN
        RAISE EXCEPTION '��� �������� "%" �� ��.���� "%" �� ������� �������������.', inUnitName, lfGet_Object_ValueData (inJuridicalId_to);
    END IF;


     -- !!!������ �� ��� ������������ <�������� ����>!!!
     -- vbObjectId:= lpGet_DefaultValue('zc_Object_Retail', vbUserId);

     -- !!!������ ��� - ������������ <�������� ����>!!!
     vbObjectId:= (SELECT ObjectLink_Juridical_Retail.ChildObjectId
                   FROM ObjectLink AS ObjectLink_Unit_Juridical
                        INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                              ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                   WHERE ObjectLink_Unit_Juridical.ObjectId = vbUnitId
                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                  );
    -- ���� �� �����, �� ����� ��������.
    IF COALESCE (vbObjectId, 0) = 0
    THEN
        RAISE EXCEPTION '� ������������� "%" �� ����������� �������� "�������� ����".', lfGet_Object_ValueData (vbUnitId);
    END IF;


     -- ���� �������� �� ����, ������, �� ����
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId)
       SELECT Movement.Id, Movement.StatusId
              INTO vbMovementId, vbStatusId
       FROM tmpStatus
            JOIN Movement ON Movement.OperDate = inOperDate 
                         AND Movement.DescId = zc_Movement_Income() 
                         AND Movement.StatusId = tmpStatus.StatusId
                         AND Movement.InvNumber = inInvNumber
            JOIN MovementLinkObject AS MovementLinkObject_From
                                    ON MovementLinkObject_From.MovementId = Movement.Id
                                   AND MovementLinkObject_From.ObjectId = inJuridicalId_from
                                   AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From();


    -- ���� ��������, �� ����� ��������.
    IF vbStatusId = zc_Enum_Status_Complete()
    THEN
        RAISE EXCEPTION '�������� ��� �������� � "%" �� "%" ��������� = "%" ������ = "%".', inInvNumber, DATE (inOperDate), lfGet_Object_ValueData (inJuridicalId_from), lfGet_Object_ValueData (vbUnitId);
    END IF;

     -- �� ��� ��� �� ����� ������, ���� ��������� ��� ��� ��� ��������� �����
     IF COALESCE (vbMovementId, 0) = 0
     THEN
       -- ���������� ������ �������      
       IF COALESCE(vbContractId, 0) = 0 THEN
        -- � ��� ��� ������� ������� �������.
          -- ���� ���� �� �����, �� ���� ����� ������� � ��������� �������
          IF inPaymentDate is null or inPaymentDate > (inOperDate + interval '1 day') THEN
             SELECT MAX(_tmpContract.ContractId) INTO vbContractId 
     	     FROM _tmpContract 
             WHERE COALESCE(_tmpContract.Deferment, 0) <> 0;
          ELSE
          -- ����� ����� ������� ��� �������� �������
             SELECT MAX(_tmpContract.ContractId) INTO vbContractId 
             FROM _tmpContract 
             WHERE COALESCE(_tmpContract.Deferment, 0) = 0;
          END IF;	     	

          -- ���� ���� �����-���� �������
          IF COALESCE(vbContractId, 0) = 0 THEN 
             SELECT MAX(_tmpContract.ContractId)  INTO vbContractId 
             FROM _tmpContract;
          END IF;

       END IF;

       --���� ���� ������ ������ - �� ���������� � �� ��������
       IF inPaymentDate is Null or inPaymentDate = '19000101'::TDateTime
       THEN
           SELECT inOperDate::Date + COALESCE(_tmpContract.Deferment, 0)::Integer
          INTO inPaymentDate
           FROM _tmpContract
           WHERE _tmpContract.ContractId = vbContractId;
       END IF;

       IF inPaymentDate IS NULL
       THEN
           inPaymentDate := inOperDate;
       END IF;
       -- ���������� ���
       SELECT Id INTO vbNDSKindId 
         FROM Object_NDSKind_View
         WHERE NDS = inVAT;
      
       IF COALESCE(vbNDSKindId, 0) = 0 THEN 

       END IF;
       

       -- ������ ������� - ��������/���� - ���� ������ 4 ����
       IF (vbContractId IN (183275)  -- ���� ����
        OR inJuridicalId_from = 59610 -- ����
          )
          AND inOperDate + INTERVAL '4 DAY' < inPaymentDate
       THEN vbContractId:= 183257; -- ���� ��������
       END IF;
       -- ������ ������� - ��������/���� - ���� ������ 4 ����
       IF (vbContractId IN (183338, 9035881) -- ������ ���� + ������ ����������
        OR inJuridicalId_from = 59611 -- �� "������-����, ���"
          )
          AND inOperDate + INTERVAL '4 DAY' < inPaymentDate
       THEN vbContractId:= 183358; -- ������ ��������
       END IF;


       vbMovementId := lpInsertUpdate_Movement_Income (ioId           := vbMovementId
                                                     , inInvNumber    := inInvNumber
                                                     , inOperDate     := inOperDate
                                                     , inPriceWithVAT := inPriceWithVAT
                                                     , inFromId       := inJuridicalId_from
                                                     , inToId         := vbUnitId
                                                     , inNDSKindId    := vbNDSKindId
                                                     , inContractId   := vbContractId 
                                                     , inPaymentDate  := inPaymentDate
                                                     , inJuridicalId  := inJuridicalId_to
                                                     , inisDifferent  := False
                                                     , inComment      := '' 
                                                     , inisUseNDSKind := vbNDSKindId = zc_Enum_NDSKind_Special_0()
                                                     , inUserId       := vbUserId);
     END IF;


    -- ������������ AreaId - ��� ������ ������ ������ ��� �������
    vbAreaId_find:= CASE WHEN EXISTS (SELECT 1
                                 FROM ObjectLink AS ObjectLink_JuridicalArea_Juridical
                                      INNER JOIN Object AS Object_JuridicalArea ON Object_JuridicalArea.Id       = ObjectLink_JuridicalArea_Juridical.ObjectId
                                                                               AND Object_JuridicalArea.isErased = FALSE
                                      INNER JOIN ObjectLink AS ObjectLink_JuridicalArea_Area
                                                            ON ObjectLink_JuridicalArea_Area.ObjectId      = Object_JuridicalArea.Id 
                                                           AND ObjectLink_JuridicalArea_Area.DescId        = zc_ObjectLink_JuridicalArea_Area()
                                                           AND ObjectLink_JuridicalArea_Area.ChildObjectId = (SELECT ObjectLink_Unit_Area.ChildObjectId
                                                                                                              FROM ObjectLink AS ObjectLink_Unit_Area
                                                                                                              WHERE ObjectLink_Unit_Area.ObjectId = vbUnitId
                                                                                                                AND ObjectLink_Unit_Area.DescId   = zc_ObjectLink_Unit_Area()
                                                                                                             )
                                      -- ���������� ��� ���������� ������ ��� �������
                                      INNER JOIN ObjectBoolean AS ObjectBoolean_JuridicalArea_GoodsCode
                                                               ON ObjectBoolean_JuridicalArea_GoodsCode.ObjectId  = Object_JuridicalArea.Id 
                                                              AND ObjectBoolean_JuridicalArea_GoodsCode.DescId    = zc_ObjectBoolean_JuridicalArea_GoodsCode()
                                                              AND ObjectBoolean_JuridicalArea_GoodsCode.ValueData = TRUE
                                 WHERE ObjectLink_JuridicalArea_Juridical.ChildObjectId = inJuridicalId_from
                                   AND ObjectLink_JuridicalArea_Juridical.DescId        = zc_ObjectLink_JuridicalArea_Juridical()
                                ) 
                    THEN -- ������ ������
                         (SELECT ObjectLink_Unit_Area.ChildObjectId
                          FROM ObjectLink AS ObjectLink_Unit_Area
                          WHERE ObjectLink_Unit_Area.ObjectId = vbUnitId
                            AND ObjectLink_Unit_Area.DescId   = zc_ObjectLink_Unit_Area()
                         )
                    ELSE 0
               END;


      -- ���� ����� ����������
      SELECT ObjectLink_Goods_Object.ObjectId INTO vbPartnerGoodsId
      FROM ObjectLink AS ObjectLink_Goods_Object
           INNER JOIN ObjectString ON ObjectString.ObjectId  = ObjectLink_Goods_Object.ObjectId
                                  AND ObjectString.DescId    = zc_ObjectString_Goods_Code()
                                  AND ObjectString.ValueData = inGoodsCode
           LEFT JOIN ObjectLink AS ObjectLink_Goods_Area
                                ON ObjectLink_Goods_Area.ObjectId = ObjectString.ObjectId
                               AND ObjectLink_Goods_Area.DescId   = zc_ObjectLink_Goods_Area()

      WHERE ObjectLink_Goods_Object.DescId        = zc_ObjectLink_Goods_Object()
        AND ObjectLink_Goods_Object.ChildObjectId = inJuridicalId_from
        AND (-- ���� ������ ������������
             COALESCE (ObjectLink_Goods_Area.ChildObjectId, 0) = vbAreaId_find
             -- ��� ��� ������ zc_Area_Basis - ����� ���� � ������� "�����"
          OR (vbAreaId_find = zc_Area_Basis() AND ObjectLink_Goods_Area.ChildObjectId IS NULL)
             -- ��� ��� ������ "�����" - ����� ���� � ������� zc_Area_Basis
          OR (vbAreaId_find = 0 AND ObjectLink_Goods_Area.ChildObjectId = zc_Area_Basis())
            )
        ;
  
     -- ���� ����� ������ ���, �� �� ��� ����������� ���������. ��� �������� �� ������������
     IF COALESCE(vbPartnerGoodsId, 0) = 0 THEN
        --
        vbPartnerGoodsId := lpInsertUpdate_Object_Goods (0, inGoodsCode, inGoodsName, NULL, NULL, NULL, inJuridicalId_from, vbUserId, NULL, inMakerName, FALSE);
        -- ��� � ������
        IF vbAreaId_find > 0
        THEN
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Area(), vbPartnerGoodsId, vbAreaId_find);
        END IF;
     END IF;
 
      -- ���� ����� ��� ���������. 
      SELECT Goods_Retail.GoodsId, ObjectLink_Goods_NDSKind.ChildObjectId  -- Object_Goods_View.NDSKindId 
             INTO vbGoodsId, vbNDSKindId
      FROM Object_LinkGoods_View AS Goods_Juridical
        LEFT JOIN Object_LinkGoods_View AS Goods_Retail
                                        ON Goods_Retail.GoodsMainId = Goods_Juridical.GoodsMainId
                                       AND Goods_Retail.ObjectId = vbObjectId
        LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                             ON ObjectLink_Goods_NDSKind.ObjectId = Goods_Retail.GoodsId
                            AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()                                        
      WHERE Goods_Juridical.GoodsId = vbPartnerGoodsId;

       
      -- �������� �������� ���������
       CREATE TEMP TABLE _tmpMI (Id Integer, PartnerGoodsId Integer, Price TFloat, PartionGoods TVarChar, ExpirationDate TDateTime) ON COMMIT DROP;
          INSERT INTO _tmpMI (Id, PartnerGoodsId, Price, PartionGoods, ExpirationDate)
                         SELECT MovementItem.Id
                              , MILinkObject_Goods.ObjectId AS PartnerGoodsId
                              , MIFloat_Price.ValueData     AS Price
                              , COALESCE(MIString_PartionGoods.ValueData, '')              AS PartionGoods
                              , COALESCE (MIDate_ExpirationDate.ValueData, zc_DateStart()) AS ExpirationDate
                         FROM MovementItem
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                     ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                    AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                              LEFT JOIN MovementItemFloat AS MIFloat_Price
                                     ON MIFloat_Price.MovementItemId = MovementItem.Id
                                    AND MIFloat_Price.DescId = zc_MIFloat_Price()
                              LEFT JOIN MovementItemString AS MIString_PartionGoods
                                     ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                    AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()  
                              LEFT JOIN MovementItemDate AS MIDate_ExpirationDate
                                     ON MIDate_ExpirationDate.MovementItemId = MovementItem.Id
                                    AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()                                         
                         WHERE MovementItem.MovementId = vbMovementId
                           AND MovementItem.DescId     = zc_MI_Master()
                           AND MovementItem.isErased = FALSE;
    -- ���� ��������� ��������� > 1
    IF EXISTS (SELECT 1
               FROM _tmpMI
               GROUP BY _tmpMI.PartnerGoodsId
                      , _tmpMI.Price
                      , _tmpMI.PartionGoods
                      , _tmpMI.ExpirationDate
               HAVING COUNT (*) > 1
              )
    THEN
        RAISE EXCEPTION '����������� ����� � ��������� � "%" �� "%" ��������� = "%" ������ = "%".', inInvNumber, DATE (inOperDate), lfGet_Object_ValueData (inJuridicalId_from), lfGet_Object_ValueData (vbUnitId);
    END IF;

     -- ���� ������� ���������. ���� �����: ��� ����������, ��������, ����, ������, ���� ��������. 
     vbMovementItemId:= (SELECT _tmpMI.Id
                         FROM _tmpMI
                         WHERE _tmpMI.PartnerGoodsId = vbPartnerGoodsId
                           AND _tmpMI.Price          = inPrice -- MovementItem.Price
                           AND _tmpMI.PartionGoods   = inPartitionGoods
                           AND _tmpMI.ExpirationDate = COALESCE (inExpirationDate, zc_DateStart())
                         );
  
     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (vbMovementItemId, 0) = 0;

     -- ��������� <������� ���������>
     vbMovementItemId := lpInsertUpdate_MovementItem_Income (vbMovementItemId, vbMovementId, vbGoodsId, inGoodsName, inAmount, inPrice, inFEA, inMeasure, vbUserId);

     -- ���������
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Goods(), vbMovementItemId, vbPartnerGoodsId);

     -- ���� �������� ������ ������
     IF inExpirationDate IS NOT NULL THEN 
        -- ��������� �������� <���� ��������>
        PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), vbMovementItemId, inExpirationDate);
     END IF;

     -- �� � �����, ���� ���� 
     IF inPartitionGoods <> '' THEN 
        -- ��������� �������� <�����>
        PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartionGoods(), vbMovementItemId, inPartitionGoods);
     END IF;
     
    -- ���� ���� �� ��� �����
     IF inSertificatNumber <> '' THEN 
        -- ��������� �������� <����� �����������>
        PERFORM lpInsertUpdate_MovementItemString (zc_MIString_SertificatNumber(), vbMovementItemId, inSertificatNumber);
     END IF;
    -- ���� ���� �� ���� ������ �����������
     IF inSertificatStart IS NOT NULL THEN
        -- ��������� �������� <���� ������ �����������>
        PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_SertificatStart(), vbMovementItemId, inSertificatStart);
     END IF;
    -- ���� ���� �� ���� ��������� �����������
     IF inSertificatEnd IS NOT NULL THEN
        -- ��������� �������� <���� ��������� �����������>
        PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_SertificatEnd(), vbMovementItemId, inSertificatEnd);
     END IF;
     
     IF inisLastRecord THEN
        -- ����������� �������� �����
        PERFORM lpInsertUpdate_MovementFloat_TotalSumm (vbMovementId);
     END IF;

     IF vbIsInsert = TRUE
     THEN
         -- ��������� ������
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), vbMovementItemId, CURRENT_TIMESTAMP);
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), vbMovementItemId, vbUserId);
    END IF;

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (vbMovementItemId, vbUserId, vbIsInsert);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.   ������ �.�.
 14.04.20                                                                                     * UseNDSKind
 11.05.18                                                                                     * 
 21.12.17         * del inCodeUKTZED
 11.12.17         * inCodeUKTZED
 15.02.17         * ������ �� ����
 01.10.15                                                                      * inSertificatNumber, inSertificatStart, inSertificatEnd
 14.01.15                        *   
 08.01.15                        *   
 29.12.14                        *   
 26.12.14                        *   
 25.12.14                        *   
 02.12.14                        *   
*/
--select * from gpInsertUpdate_MovementItem_Income_MMOLoad(inOKPOFrom := '36852896', inOKPOTo := '2591702304' , inInvNumber := '6612083' , inOperDate := ('15.02.2017')::TDateTime , inInvTaxNumber := '6612083' , inPaymentDate := ('27.02.2017')::TDateTime , inPriceWithVAT := 'False' , inSyncCode := 1 , inRemark := '�� "������ �. �.", �.��������������, ��.������, 6' , inGoodsCode := '28036' , inGoodsName := '˳������ ����. �/� 20�� �30' , inMakerCode := '292' , inMakerName := '�������' , inCommonCode := 155344 , inVAT := 7 , inPartitionGoods := 'R71613' , inExpirationDate := ('01.05.2019')::TDateTime , inAmount := 10 , inPrice := 523.57 , inFea := '3004900000' , inMeasure := '���' , inSertificatNumber := 'UA/2377/01/01' , inSertificatStart := ('27.06.2014')::TDateTime , inSertificatEnd := ('27.06.2019')::TDateTime , inisLastRecord := 'True' ,  inSession := '1871720');

