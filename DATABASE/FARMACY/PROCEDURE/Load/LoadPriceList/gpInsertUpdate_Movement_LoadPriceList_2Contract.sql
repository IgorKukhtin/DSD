DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_LoadPriceList_2Contract
          (Integer, Integer, Integer, Integer, 
           TVarChar, TVarChar, TVarChar, TVarChar,
           TFloat, TFloat, TFloat,
           TDateTime,
           TVarChar, TVarChar, 
           Boolean,
           TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_LoadPriceList_2Contract(
    IN inJuridicalId         Integer   , -- ����������� ����
    IN inContractId1         Integer   , -- �������
    IN inContractId2         Integer   , -- �������
    IN inCommonCode          Integer   , 
    IN inBarCode             TVarChar  , 
    IN inGoodsCode           TVarChar  , 
    IN inGoodsName           TVarChar  , 
    IN inGoodsNDS            TVarChar  , 
    IN inPrice1              TFloat    ,  
    IN inPrice2              TFloat    ,  
    IN inRemains             TFloat    ,  
    IN inExpirationDate      TDateTime , -- ���� ��������
    IN inPackCount           TVarChar  ,  
    IN inProducerName        TVarChar  , 
    IN inNDSinPrice          Boolean   ,
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE vbLoadPriceListId1 Integer;
    DECLARE vbLoadPriceListItemsId1 Integer;
    DECLARE vbLoadPriceListId2 Integer;
    DECLARE vbLoadPriceListItemsId2 Integer;
    DECLARE vbGoodsId Integer;
    DECLARE vbPriceOriginal TFloat;
    DECLARE vbIsSpecCondition Boolean;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
    vbUserId:= lpGetUserBySession (inSession);

	
    -- ����� �� ���������
    IF COALESCE (inPrice1, 0) = 0 AND COALESCE (inPrice2, 0) = 0 THEN 
        RETURN;
    END IF;
  
    -- �������� 
    IF COALESCE (inJuridicalId, 0) = 0 THEN 
        RAISE EXCEPTION '�� ����������� �������� ��������� ����������� ���� (JuridicalId)';
    END IF;
    -- �������� ��� �������� ���� �� ���� � �� �������
    IF (SELECT DescId FROM Object WHERE Id = inJuridicalId) <> zc_Object_Juridical() THEN
        RAISE EXCEPTION '�� ��������� ���������� �������� ��������� ����������� ���� (JuridicalId)';
    END IF;
  
    -- ��� 1
    IF COALESCE (inPrice1, 0) <> 0 THEN
        -- �������� ��� �������� ���� ������� � �� �� ���� 
        IF COALESCE(inContractId1, 0) <> 0 THEN 
            IF (SELECT DescId FROM Object WHERE Id = inContractId1) <> zc_Object_Contract() THEN
                RAISE EXCEPTION '�� ��������� ���������� �������� ��������� ������� 1 (ContractId1)';
            END IF;
        END IF;
    END IF;
    -- ��� 2
    IF COALESCE(inPrice2, 0) <> 0
    THEN
        -- �������� ��� �������� ���� ������� � �� �� ���� 
        IF COALESCE(inContractId2, 0) <> 0 THEN 
            IF (SELECT DescId FROM Object WHERE Id = inContractId2) <> zc_Object_Contract() THEN
                RAISE EXCEPTION '�� ��������� ���������� �������� ��������� ������� 2 (ContractId2)';
            END IF;
        END IF;
    END IF;
  

    -- !!!��������!!! ���������� ������ - ��������
    DELETE FROM LoadPriceListItem WHERE LoadPriceListId IN
      (SELECT Id FROM LoadPriceList WHERE JuridicalId = inJuridicalId  AND COALESCE (ContractId, 0) IN (inContractId1, inContractId2)
                                      AND OperDate < CURRENT_DATE);
     -- !!!��������!!! ���������� ������ - �����
    DELETE FROM LoadPriceList WHERE Id IN
      (SELECT Id FROM LoadPriceList WHERE JuridicalId = inJuridicalId  AND COALESCE (ContractId, 0) IN (inContractId1, inContractId2)
                                      AND OperDate < CURRENT_DATE);
  
    -- ��� 1
    IF COALESCE (inPrice1, 0) <> 0
    THEN 
        -- ����� "�����1" �� "�������"
        SELECT Id INTO vbLoadPriceListId1
        FROM LoadPriceList
        WHERE JuridicalId = inJuridicalId AND OperDate = CURRENT_DATE AND COALESCE (ContractId, 0) = inContractId1;

        -- ���� ��� "�����1" - ��������
        IF COALESCE (vbLoadPriceListId1, 0) = 0 THEN
            INSERT INTO LoadPriceList (JuridicalId, ContractId, OperDate, NDSinPrice/*, UserId_Insert*/, Date_Insert)
                               VALUES (inJuridicalId, inContractId1, CURRENT_DATE, inNDSinPrice/*, vbUserId*/, CURRENT_TIMESTAMP);
        /*ELSE
            -- ����� � �������� ������� ��� ���� Insert
            UPDATE LoadPriceList SET UserId_Insert = vbUserId, Date_Insert = CURRENT_TIMESTAMP WHERE Id = vbLoadPriceListId1;*/
        END IF;

        -- ����� "��������1"
        SELECT Id INTO vbLoadPriceListItemsId1 FROM LoadPriceListItem  WHERE LoadPriceListId = vbLoadPriceListId1  AND GoodsCode = inGoodsCode;

    END IF;
  
    -- ��� 2
    IF COALESCE (inPrice2, 0) <> 0 THEN
        -- ����� "�����2" �� "�������"
        SELECT Id INTO vbLoadPriceListId2
        FROM LoadPriceList
        WHERE JuridicalId = inJuridicalId AND OperDate = CURRENT_DATE AND COALESCE (ContractId, 0) = inContractId2;
          
        -- ���� ��� "�����2" - ��������
        IF COALESCE (vbLoadPriceListId2, 0) = 0 THEN
            INSERT INTO LoadPriceList (JuridicalId, ContractId, OperDate, NDSinPrice/*, UserId_Insert*/, Date_Insert)
                               VALUES (inJuridicalId, inContractId2, CURRENT_DATE, inNDSinPrice/*, vbUserId*/, CURRENT_TIMESTAMP);
        /*ELSE
            -- ����� � �������� ������� ��� ���� Insert
            UPDATE LoadPriceList SET UserId_Insert = vbUserId, Date_Insert = CURRENT_TIMESTAMP WHERE Id = vbLoadPriceListId2;*/
        END IF;

        -- ����� "��������1"
        SELECT Id INTO vbLoadPriceListItemsId2 FROM LoadPriceListItem WHERE LoadPriceListId = vbLoadPriceListId2 AND GoodsCode = inGoodsCode;

    END IF;   


    -- ���� �� ������ ���� 
    IF COALESCE (vbGoodsId, 0) = 0 AND inCommonCode > 0
    THEN
      SELECT ObjectLink_LinkGoods_GoodsMain.ChildObjectId AS GoodsId
           , tmp.isSpecCondition
             INTO vbGoodsId, vbIsSpecCondition
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
             LEFT JOIN (SELECT ObjectLink_LinkGoods_GoodsMain.ChildObjectId AS GoodsId
                             , ObjectBoolean_Goods_SpecCondition.ValueData  AS isSpecCondition
                        FROM ObjectLink AS ObjectLink_Goods_Object
                             JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                                             ON ObjectLink_LinkGoods_Goods.ChildObjectId = ObjectLink_Goods_Object.ObjectId
                                            AND ObjectLink_LinkGoods_Goods.DescId        = zc_ObjectLink_LinkGoods_Goods()
                             JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                                             ON ObjectLink_LinkGoods_GoodsMain.ObjectId = ObjectLink_LinkGoods_Goods.ObjectId
                                            AND ObjectLink_LinkGoods_GoodsMain.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                             LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_SpecCondition
                                                     ON ObjectBoolean_Goods_SpecCondition.ObjectId = ObjectLink_Goods_Object.ObjectId
                                                    AND ObjectBoolean_Goods_SpecCondition.DescId = zc_ObjectBoolean_Goods_SpecCondition()
                        WHERE ObjectLink_Goods_Object.ChildObjectId = inJuridicalId
                          AND ObjectLink_Goods_Object.DescId        = zc_ObjectLink_Goods_Object()
                       ) AS tmp ON tmp.GoodsId = ObjectLink_LinkGoods_GoodsMain.ChildObjectId

      WHERE Object_Goods.ObjectCode = inCommonCode
        AND Object_Goods.DescId = zc_Object_Goods();

    END IF;
   
    -- ���� �� �����-���� 
    IF COALESCE (vbGoodsId, 0) = 0 AND inBarCode <> ''
    THEN
      SELECT ObjectLink_LinkGoods_GoodsMain.ChildObjectId AS GoodsId
           , ObjectBoolean_Goods_SpecCondition.ValueData  AS isSpecCondition
             INTO vbGoodsId, vbIsSpecCondition
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
             LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_SpecCondition
                                     ON ObjectBoolean_Goods_SpecCondition.ObjectId = Object_Goods.Id
                                    AND ObjectBoolean_Goods_SpecCondition.DescId = zc_ObjectBoolean_Goods_SpecCondition()
      WHERE Object_Goods.ValueData = inBarCode
        AND Object_Goods.DescId = zc_Object_Goods();
    END IF;

    -- ���� �� ���� � inJuridicalId
    IF (COALESCE(vbGoodsId, 0) = 0) THEN
        SELECT ObjectLink_LinkGoods_GoodsMain.ChildObjectId AS GoodsId
             , ObjectBoolean_Goods_SpecCondition.ValueData  AS isSpecCondition
               INTO vbGoodsId, vbIsSpecCondition
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
             LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_SpecCondition
                                     ON ObjectBoolean_Goods_SpecCondition.ObjectId = ObjectString.ObjectId
                                    AND ObjectBoolean_Goods_SpecCondition.DescId = zc_ObjectBoolean_Goods_SpecCondition()
      WHERE ObjectString.ValueData = inGoodsCode
        AND ObjectString.DescId = zc_ObjectString_Goods_Code();
    END IF;


    -- !!!������ ���������!!!
    IF inExpirationDate IS NULL OR inExpirationDate = CURRENT_DATE
    THEN 
        inExpirationDate := zc_DateEnd();
    END IF;	

    --!!!��������!!!
    IF 1 < (SELECT COUNT (*) FROM (SELECT DISTINCT CASE WHEN vbIsSpecCondition = TRUE
                             AND ObjectFloat_ConditionalPercent.ValueData <> 0
                                 THEN CAST (tmp.Price * (1 + ObjectFloat_ConditionalPercent.ValueData / 100) AS NUMERIC (16, 2))
                            ELSE tmp.Price
                       END
                FROM (SELECT inPrice1 AS Price) AS tmp
                     LEFT JOIN ObjectFloat AS ObjectFloat_ConditionalPercent 
                                           ON ObjectFloat_ConditionalPercent.ObjectId = inJuridicalId 
                                          AND ObjectFloat_ConditionalPercent.DescId = zc_ObjectFloat_Juridical_ConditionalPercent()
               ) AS tmp)
    THEN
        RAISE EXCEPTION '������ � ����������� inJuridicalId = <%> + vbGoodsId = <%>', inJuridicalId, vbGoodsId;
    END IF;

    --!!!����� - ���������!!!
    vbPriceOriginal:= inPrice1;
    --!!!����� - ������!!!
    inPrice1:= (SELECT CASE WHEN vbIsSpecCondition = TRUE
                             AND ObjectFloat_ConditionalPercent.ValueData <> 0
                                 THEN CAST (tmp.Price * (1 + ObjectFloat_ConditionalPercent.ValueData / 100) AS NUMERIC (16, 2))
                            ELSE tmp.Price
                       END
                FROM (SELECT inPrice1 AS Price) AS tmp
                     LEFT JOIN ObjectFloat AS ObjectFloat_ConditionalPercent 
                                           ON ObjectFloat_ConditionalPercent.ObjectId = inJuridicalId 
                                          AND ObjectFloat_ConditionalPercent.DescId = zc_ObjectFloat_Juridical_ConditionalPercent()
               );

    -- ��� 1
    IF COALESCE (inPrice1, 0) <> 0 THEN
        -- ���������� "��������1"
        IF COALESCE(vbLoadPriceListItemsId1, 0) = 0 THEN
            INSERT INTO LoadPriceListItem (LoadPriceListId, CommonCode, BarCode, GoodsCode, GoodsName, GoodsNDS, GoodsId, Price, PriceOriginal, ExpirationDate, PackCount, ProducerName)
                                   VALUES (vbLoadPriceListId1, inCommonCode, inBarCode, inGoodsCode, inGoodsName, inGoodsNDS, vbGoodsId, inPrice1, vbPriceOriginal, inExpirationDate, inPackCount, inProducerName);
        ELSE
            UPDATE LoadPriceListItem 
             SET GoodsName = inGoodsName, CommonCode = inCommonCode, BarCode = inBarCode, GoodsNDS = inGoodsNDS, GoodsId = vbGoodsId, 
                 Price = inPrice1, PriceOriginal = vbPriceOriginal, ExpirationDate = inExpirationDate, PackCount = inPackCount, ProducerName = inProducerName
            WHERE Id = vbLoadPriceListItemsId1;
        END IF;
    END IF; 

    --!!!����� - ���������!!!
    vbPriceOriginal:= inPrice2;
    --!!!����� - ������!!!
    inPrice2:= (SELECT CASE WHEN vbIsSpecCondition = TRUE
                             AND ObjectFloat_ConditionalPercent.ValueData <> 0
                                 THEN CAST (tmp.Price * (1 + ObjectFloat_ConditionalPercent.ValueData / 100) AS NUMERIC (16, 2))
                            ELSE tmp.Price
                       END
                FROM (SELECT inPrice2 AS Price) AS tmp
                     LEFT JOIN ObjectFloat AS ObjectFloat_ConditionalPercent 
                                           ON ObjectFloat_ConditionalPercent.ObjectId = inJuridicalId 
                                          AND ObjectFloat_ConditionalPercent.DescId = zc_ObjectFloat_Juridical_ConditionalPercent()
               );
    -- ��� 2
    IF COALESCE (inPrice2, 0) <> 0 THEN   
        -- ���������� "��������2"
        IF COALESCE(vbLoadPriceListItemsId2, 0) = 0 THEN
            INSERT INTO LoadPriceListItem (LoadPriceListId, CommonCode, BarCode, GoodsCode, GoodsName, GoodsNDS, GoodsId, Price, PriceOriginal, ExpirationDate, PackCount, ProducerName)
                                   VALUES (vbLoadPriceListId2, inCommonCode, inBarCode, inGoodsCode, inGoodsName, inGoodsNDS, vbGoodsId, inPrice2, vbPriceOriginal, inExpirationDate, inPackCount, inProducerName);
        ELSE
            UPDATE LoadPriceListItem 
            SET GoodsName = inGoodsName, CommonCode = inCommonCode, BarCode = inBarCode, GoodsNDS = inGoodsNDS, GoodsId = vbGoodsId, 
                 Price = inPrice2, PriceOriginal = vbPriceOriginal, ExpirationDate = inExpirationDate, PackCount = inPackCount, ProducerName = inProducerName
            WHERE Id = vbLoadPriceListItemsId2;
        END IF;
    END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.
 14.03.2016                                      * all
 07.10.2015                                                                    *�������� ����� � 2 ������
 17.02.15                        *   ����� ����� �� ������. 
 11.11.14                        *   
 28.10.14                        *   
 22.10.14                        *   ������� ����������� ������
 18.09.14                        *  
*/
