DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income_Load 
          (Integer, TVarChar, TDateTime,
           Integer, TVarChar, TVarChar, TVarChar, 
           TFloat, TFloat,
           TDateTime, TDateTime, 
           Boolean,
           TVarChar,
           TVarChar);

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income_Load 
          (Integer, TVarChar, TDateTime,
           Integer, TVarChar, TVarChar, TVarChar, 
           TFloat, TFloat,
           TDateTime, TDateTime, 
           Boolean,
           TVarChar,
           Boolean,
           TVarChar);

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income_Load 
          (Integer, TVarChar, TDateTime,
           Integer, TVarChar, TVarChar, TVarChar, 
           TFloat, TFloat,
           TDateTime, 
           TVarChar,
           TDateTime, 
           Boolean,
           TVarChar,
           Boolean,
           TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income_Load 
          (Integer, TVarChar, TDateTime,
           Integer, TVarChar, TVarChar, TVarChar, 
           TFloat, TFloat,
           TDateTime, 
           TVarChar,
           TDateTime, 
           Boolean,
           TVarChar,
           TVarChar,
           Boolean,
           TVarChar);

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income_Load 
          (Integer, TVarChar, TDateTime,
           Integer, TVarChar, TVarChar, TVarChar, 
           TFloat, TFloat,
           TDateTime, 
           TVarChar,
           TDateTime, 
           Boolean,
           TFloat, 
           TVarChar,
           TVarChar,
           Boolean,
           TVarChar);

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income_Load 
          (Integer, TVarChar, TDateTime,
           Integer, TVarChar, TVarChar, TVarChar, 
           TFloat, TFloat,
           TDateTime, 
           TVarChar,
           TDateTime, 
           Boolean,
           TFloat, 
           TVarChar,
           TVarChar,
           TVarChar,
           TVarChar,
           Boolean,
           TVarChar);

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income_Load 
          (Integer, TVarChar, TDateTime,
           Integer, TVarChar, TVarChar, TVarChar, 
           TFloat, TFloat,
           TDateTime, 
           TVarChar,
           TDateTime, 
           Boolean,
           TFloat, 
           TVarChar,
           TVarChar,
           TVarChar,
           TVarChar,
           TVarChar,
           TDateTime, 
           TDateTime, 
           Boolean,
           TVarChar);
CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Income_Load(
    IN inJuridicalId         Integer   , -- ����������� ����
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
BEGIN
	
     -- ������������ <������������>
     vbUserId := lpGetUserBySession (inSession);


         -- ���� ������������� � �������. ��� � �����
         SELECT tmp.ContractId, tmp.UnitId
                INTO vbContractId, vbUnitId
         FROM (WITH tmpList AS (SELECT Object_ImportExportLink_View.ValueId                                       AS ContractId -- ����� �������
                                     , Object_ImportExportLink_View.MainId                                        AS UnitId
                                     , LOWER (TRIM (Object_ImportExportLink_View.StringKey)) :: TVarChar          AS StringKey
                                     , LOWER (zfCalc_Word_Split (Object_ImportExportLink_View.StringKey, '%', 1)) AS StringKey1
                                     , LOWER (zfCalc_Word_Split (Object_ImportExportLink_View.StringKey, '%', 2)) AS StringKey2
                                     , LOWER (zfCalc_Word_Split (Object_ImportExportLink_View.StringKey, '%', 3)) AS StringKey3
                                FROM Object_Contract_View
                                     INNER JOIN Object_ImportExportLink_View ON Object_ImportExportLink_View.ValueId = Object_Contract_View.Id
                                WHERE Object_Contract_View.JuridicalId = inJuridicalId
                               )
               -- ����� ���������
               SELECT tmpList.ContractId, tmpList.UnitId
               FROM tmpList
               WHERE (LOWER (inUnitName) = StringKey AND StringKey  <> '' AND StringKey1 = '' AND StringKey2 = '' AND StringKey3 = '')
                  OR (LOWER (inUnitName) LIKE '%' || StringKey1 || '%' AND StringKey1 <> '' AND StringKey2 = '' AND StringKey3 = '')
                  OR (LOWER (inUnitName) LIKE '%' || StringKey1 || '%' AND LOWER (inUnitName) LIKE '%' || StringKey2 AND StringKey1 <> '' AND StringKey2 <> '' AND StringKey3 = '')
                  OR (LOWER (inUnitName) LIKE '%' || StringKey1 || '%' AND LOWER (inUnitName) LIKE '%' || StringKey2 || '%' AND LOWER (inUnitName) LIKE '%' || StringKey3 || '%' AND StringKey1 <> '' AND StringKey2 <> '' AND StringKey3 <> '')
              ) AS tmp;


     -- ���� �� ����� - ���� ������������� �� ������, � ��� ������� - ����� �����...
     IF COALESCE (vbUnitId, 0) = 0
     THEN

         SELECT tmp.UnitId
                INTO vbUnitId
         FROM (WITH tmpList AS (SELECT Object_ImportExportLink_View.ValueId                                       AS JuridicalId -- ����� ��.����
                                     , Object_ImportExportLink_View.MainId                                        AS UnitId
                                     , LOWER (TRIM (Object_ImportExportLink_View.StringKey)) :: TVarChar          AS StringKey
                                     , LOWER (zfCalc_Word_Split (Object_ImportExportLink_View.StringKey, '%', 1)) AS StringKey1
                                     , LOWER (zfCalc_Word_Split (Object_ImportExportLink_View.StringKey, '%', 2)) AS StringKey2
                                     , LOWER (zfCalc_Word_Split (Object_ImportExportLink_View.StringKey, '%', 3)) AS StringKey3
                                FROM Object_ImportExportLink_View
                                WHERE Object_ImportExportLink_View.ValueId = inJuridicalId
                               )
               -- ����� ���������
               SELECT tmpList.JuridicalId, tmpList.UnitId
               FROM tmpList
               WHERE (LOWER (inUnitName) = StringKey AND StringKey  <> '' AND StringKey1 = '' AND StringKey2 = '' AND StringKey3 = '')
                  OR (LOWER (inUnitName) LIKE '%' || StringKey1 || '%' AND StringKey1 <> '' AND StringKey2 = '' AND StringKey3 = '')
                  OR (LOWER (inUnitName) LIKE '%' || StringKey1 || '%' AND LOWER (inUnitName) LIKE '%' || StringKey2 AND StringKey1 <> '' AND StringKey2 <> '' AND StringKey3 = '')
                  OR (LOWER (inUnitName) LIKE '%' || StringKey1 || '%' AND LOWER (inUnitName) LIKE '%' || StringKey2 || '%' AND LOWER (inUnitName) LIKE '%' || StringKey3 || '%' AND StringKey1 <> '' AND StringKey2 <> '' AND StringKey3 <> '')
              ) AS tmp;

    END IF;


    -- ���� �� �����, �� ����� ��������. !!!������������� ������ ����!!!
    IF COALESCE (vbUnitId, 0) = 0
    THEN
        RAISE EXCEPTION '��� �������� <%> �� ��.���� <%> �� ������� �������������.', inUnitName, lfGet_Object_ValueData (inJuridicalId);
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
        RAISE EXCEPTION '� ������������� <%> �� ����������� �������� <�������� ����>.', lfGet_Object_ValueData (vbUnitId);
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
                                   AND MovementLinkObject_From.ObjectId = inJuridicalId
                                   AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From();


     -- �� ��� ��� �� ����� ������, ���� ��������� ��� ��� ��� ��������� �����
     IF COALESCE (vbMovementId, 0) = 0
     THEN
       -- ���������� ������ �������      
       IF COALESCE(vbContractId, 0) = 0 THEN
        -- � ��� ��� ������� ������� �������.
          -- ���� ���� �� �����, �� ���� ����� ������� � ��������� �������
          IF inPaymentDate is null or inPaymentDate > (inOperDate + interval '1 day') THEN
             SELECT MAX(Id) INTO vbContractId 
     	       FROM Object_Contract_View 
              WHERE Object_Contract_View.JuridicalId = inJuridicalId AND COALESCE(Deferment, 0) <> 0;
          ELSE
          -- ����� ����� ������� ��� �������� �������
             SELECT MAX(Id) INTO vbContractId 
               FROM Object_Contract_View 
              WHERE Object_Contract_View.JuridicalId = inJuridicalId AND COALESCE(Deferment, 0) = 0;
          END IF;	     	

          -- ���� ���� �����-���� �������
          IF COALESCE(vbContractId, 0) = 0 THEN 
             SELECT MAX(Id) INTO vbContractId 
               FROM Object_Contract_View 
              WHERE Object_Contract_View.JuridicalId = inJuridicalId;
          END IF;
       END IF;
       --���� ���� ������ ������ - �� ���������� � �� ��������
       IF inPaymentDate is Null or inPaymentDate = '19000101'::TDateTime
       THEN
           SELECT
               inOperDate::Date + COALESCE(Deferment, 0)::Integer
           INTO
               inPaymentDate
           FROM
               Object_Contract_View
           WHERE
               Object_Contract_View.Id = vbContractId;
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

       vbMovementId := lpInsertUpdate_Movement_Income(vbMovementId, inInvNumber, inOperDate, inPriceWithVAT, 
                                                      inJuridicalId, vbUnitId, vbNDSKindId
                                                     ,inContractId := vbContractId 
                                                     ,inPaymentDate := inPaymentDate
                                                     ,inJuridicalId := (Select ObjectLink.ChildObjectId 
                                                                        from ObjectLink 
                                                                        Where ObjectLink.ObjectId = vbUnitId
                                                                          AND ObjectLink.DescId = zc_ObjectLink_Unit_Juridical())
                                                     ,inUserId := vbUserId);
     END IF;



  -- ���� ����� 
      SELECT Goods_Juridical.Id INTO vbPartnerGoodsId
        FROM Object_Goods_View AS Goods_Juridical

       WHERE Goods_Juridical.ObjectId = inJuridicalId AND Goods_Juridical.GoodsCode = inGoodsCode;
  
    --���� ����� ������ ���, �� �� ��� ����������� ���������. ��� �������� �� ������������
     IF COALESCE(vbPartnerGoodsId, 0) = 0 THEN
        vbPartnerGoodsId := lpInsertUpdate_Object_Goods(0, inGoodsCode, inGoodsName, NULL, NULL, NULL, inJuridicalId, vbUserId, NULL, inMakerName, false);    
     END IF;
 
  -- ���� ����� ��� ���������. 
      SELECT Goods_Retail.GoodsId, Object_Goods_View.NDSKindId INTO vbGoodsId, vbNDSKindId
        FROM Object_LinkGoods_View AS Goods_Juridical
        LEFT JOIN Object_LinkGoods_View AS Goods_Retail ON Goods_Retail.GoodsMainId = Goods_Juridical.GoodsMainId
                                                  AND Goods_Retail.ObjectId = vbObjectId
        LEFT JOIN Object_Goods_View ON Goods_Retail.GoodsId = Object_Goods_View.Id                                          

       WHERE Goods_Juridical.GoodsId = vbPartnerGoodsId;

  -- ���� ����� � ���������. ���� �����: ��� ����������, ��������, ����, ������, ���� ��������. 
     SELECT MovementItem.Id INTO vbMovementItemId
       FROM MovementItem_Income_View AS MovementItem
        
      WHERE MovementItem.MovementId = vbMovementId
        AND MovementItem.PartnerGoodsId = vbPartnerGoodsId
        AND MovementItem.Price = inPrice--MovementItem.Price
        AND MovementItem.PartionGoods = inPartitionGoods
        AND MovementItem.ExpirationDate = inExpirationDate;
  
     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (vbMovementItemId, 0) = 0;

     -- ��������� <������� ���������>
     vbMovementItemId := lpInsertUpdate_MovementItem_Income (vbMovementItemId, vbMovementId, vbGoodsId, inAmount, inPrice, inFEA, inMeasure, vbUserId);

     -- ���������
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Goods(), vbMovementItemId, vbPartnerGoodsId);

     -- ���� �������� ������ ������
     IF NOT (inExpirationDate IS NULL) THEN 
        -- ��������� �������� <���� ��������>
        PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), vbMovementItemId, inExpirationDate);
     END IF;

     -- �� � �����, ���� ���� 
     IF COALESCE(inPartitionGoods, '') <> '' THEN 
        -- ��������� �������� <�����>
        PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartionGoods(), vbMovementItemId, inPartitionGoods);
     END IF;
     
    -- ���� ���� �� ��� �����
     IF COALESCE(inSertificatNumber, '') <> '' THEN 
        -- ��������� �������� <����� �����������>
        PERFORM lpInsertUpdate_MovementItemString (zc_MIString_SertificatNumber(), vbMovementItemId, inSertificatNumber);
     END IF;
    -- ���� ���� �� ���� ������ �����������
     IF inSertificatStart is not null THEN 
        -- ��������� �������� <���� ������ �����������>
        PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_SertificatStart(), vbMovementItemId, inSertificatStart);
     END IF;
    -- ���� ���� �� ���� ��������� �����������
     IF inSertificatEnd is not null THEN 
        -- ��������� �������� <���� ��������� �����������>
        PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_SertificatEnd(), vbMovementItemId, inSertificatEnd);
     END IF;

     IF inisLastRecord THEN
        -- ����������� �������� �����
        PERFORM lpInsertUpdate_MovementFloat_TotalSumm (vbMovementId);
     END IF;


     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (vbMovementItemId, vbUserId, vbIsInsert);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.
 01.10.15                                                                      * inSertificatNumber, inSertificatStart, inSertificatEnd
 14.01.15                        *   
 08.01.15                        *   
 29.12.14                        *   
 26.12.14                        *   
 25.12.14                        *   
 02.12.14                        *   
*/
