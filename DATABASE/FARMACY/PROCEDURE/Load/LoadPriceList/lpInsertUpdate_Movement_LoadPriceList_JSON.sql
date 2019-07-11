DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_LoadPriceList_JSON (Integer, Integer, Integer, Boolean, Text, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_LoadPriceList_JSON(
    IN inJuridicalId         Integer   , -- ����������� ����
    IN inContractId          Integer   , -- �������
    IN inAreaId              Integer   , -- ������
    IN inNDSinPrice          Boolean   , -- ���� � ���
    IN inJSON                Text      , -- json
    IN inPriceNum            Integer   , -- ����� ���� ��� ���������� ����������
    IN inUserId              Integer     -- ������������
)
RETURNS VOID
AS
$BODY$

    DECLARE vbLoadPriceListId Integer;
    DECLARE vbAreaId_find Integer;
    DECLARE vbConditionalPercent TFloat;

BEGIN
    -- �� JSON � �������
    DROP TABLE IF EXISTS tblJSON;
    CREATE TABLE tblJSON
    (
     GoodsID			   Integer   ,
     PriceOriginal         TFloat    ,
     isSpecCondition       Boolean   ,

     inCommonCode          Integer   ,
     inBarCode             TVarChar  ,
     inGoodsCode           TVarChar  ,
     inGoodsName           TVarChar  ,
     inGoodsNDS            TVarChar  ,
     inPrice               TFloat    ,
     inPrice1              TFloat    ,
     inPrice2              TFloat    ,
     inPrice3              TFloat    ,
     inRemains             TFloat    ,
     inExpirationDate      TDateTime ,
     inPackCount           TVarChar  ,
     inProducerName        TVarChar  ,
     inCodeUKTZED          TVarChar
    );

    DROP TABLE IF EXISTS tblJSON_temp;
    CREATE TABLE tblJSON_temp
    (
      inJSON                Text -- json
    );

    INSERT INTO tblJSON_temp
    SELECT inJSON;

    INSERT INTO tblJSON
    SELECT *
    FROM json_populate_recordset(null::tblJSON, replace(replace(replace(inJSON, '&quot;', '\"'), CHR(9),''), CHR(10),'')::json);
    --FROM json_populate_recordset(null::tblJSON, inJSON::json);

    CREATE INDEX idx_tblJSON_CommonCode ON tblJSON USING btree (inCommonCode);
    CREATE INDEX idx_tblJSON_BarCode ON tblJSON USING btree (inBarCode);

    -- �������� ��� �������� ���� ������� � �� �� ����
    IF COALESCE (inContractId, 0) <> 0 THEN
       IF (SELECT DescId FROM Object WHERE Id = inContractId) <> zc_Object_Contract() THEN
          RAISE EXCEPTION '�� ��������� ���������� �������� ��������� ������� (ContractId)';
       END IF;
    END IF;


    -- �������� ��� �������� ���� ������ � �� ������ ...
    IF COALESCE (inAreaId, 0) <> 0 THEN
       IF (SELECT DescId FROM Object WHERE Id = inAreaId) <> zc_Object_Area() THEN
          RAISE EXCEPTION '�� ��������� ���������� �������� ��������� ������ (AreaId)';
       END IF;
    END IF;

    -- �������� ��� ������ ������������� �� ����
    IF (COALESCE (inAreaId, 0) = 0 AND EXISTS (SELECT 1
                                               FROM ObjectLink AS ObjectLink_JuridicalArea_Juridical
                                                    INNER JOIN Object AS Object_JuridicalArea ON Object_JuridicalArea.Id       = ObjectLink_JuridicalArea_Juridical.ObjectId
                                                                                             AND Object_JuridicalArea.isErased = FALSE
                                                    -- INNER JOIN ObjectLink AS ObjectLink_JuridicalArea_Area
                                                    --                       ON ObjectLink_JuridicalArea_Area.ObjectId      = Object_JuridicalArea.Id
                                                    --                      AND ObjectLink_JuridicalArea_Area.DescId        = zc_ObjectLink_JuridicalArea_Area()
                                                    --                      AND ObjectLink_JuridicalArea_Area.ChildObjectId > 0

                                               WHERE ObjectLink_JuridicalArea_Juridical.ChildObjectId = inJuridicalId
                                                 AND ObjectLink_JuridicalArea_Juridical.DescId        = zc_ObjectLink_JuridicalArea_Juridical()
                                              ))
              OR (inAreaId > 0 AND NOT EXISTS (SELECT 1
                                               FROM ObjectLink AS ObjectLink_JuridicalArea_Juridical
                                                    INNER JOIN Object AS Object_JuridicalArea ON Object_JuridicalArea.Id       = ObjectLink_JuridicalArea_Juridical.ObjectId
                                                                                             AND Object_JuridicalArea.isErased = FALSE
                                                    INNER JOIN ObjectLink AS ObjectLink_JuridicalArea_Area
                                                                          ON ObjectLink_JuridicalArea_Area.ObjectId      = Object_JuridicalArea.Id
                                                                         AND ObjectLink_JuridicalArea_Area.DescId        = zc_ObjectLink_JuridicalArea_Area()
                                                                         AND ObjectLink_JuridicalArea_Area.ChildObjectId = inAreaId

                                               WHERE ObjectLink_JuridicalArea_Juridical.ChildObjectId = inJuridicalId
                                                 AND ObjectLink_JuridicalArea_Juridical.DescId        = zc_ObjectLink_JuridicalArea_Juridical()
                                              ))
    THEN
        RAISE EXCEPTION '������.��� <%>%�� ��������� ���������� �������� ��������� ������ = <%>%�������� ������ ���� �� ������: <%>'
                      , lfGet_Object_ValueData (inJuridicalId)
                      , CHR (13)
                      , lfGet_Object_ValueData (inAreaId)
                      , CHR (13)
                      , (SELECT STRING_AGG (tmp.AreaName, ';')
                         FROM (SELECT COALESCE (Object_Area.ValueData, '') AS AreaName
                               FROM ObjectLink AS ObjectLink_JuridicalArea_Juridical
                                    INNER JOIN Object AS Object_JuridicalArea ON Object_JuridicalArea.Id       = ObjectLink_JuridicalArea_Juridical.ObjectId
                                                                             AND Object_JuridicalArea.isErased = FALSE
                                    LEFT JOIN ObjectLink AS ObjectLink_JuridicalArea_Area
                                                         ON ObjectLink_JuridicalArea_Area.ObjectId      = Object_JuridicalArea.Id
                                                        AND ObjectLink_JuridicalArea_Area.DescId        = zc_ObjectLink_JuridicalArea_Area()
                                    LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_JuridicalArea_Area.ChildObjectId
                               WHERE ObjectLink_JuridicalArea_Juridical.ChildObjectId = inJuridicalId
                                 AND ObjectLink_JuridicalArea_Juridical.DescId        = zc_ObjectLink_JuridicalArea_Juridical()
                              ) AS tmp
                        )
                       ;
    END IF;


    -- ������������ AreaId - ��� ������ ������ ������ ��� �������
    vbAreaId_find:= CASE WHEN EXISTS (SELECT 1
                                      FROM ObjectLink AS ObjectLink_JuridicalArea_Juridical
                                           INNER JOIN Object AS Object_JuridicalArea ON Object_JuridicalArea.Id       = ObjectLink_JuridicalArea_Juridical.ObjectId
                                                                                    AND Object_JuridicalArea.isErased = FALSE
                                           INNER JOIN ObjectLink AS ObjectLink_JuridicalArea_Area
                                                                 ON ObjectLink_JuridicalArea_Area.ObjectId      = Object_JuridicalArea.Id
                                                                AND ObjectLink_JuridicalArea_Area.DescId        = zc_ObjectLink_JuridicalArea_Area()
                                                                AND ObjectLink_JuridicalArea_Area.ChildObjectId = inAreaId
                                           -- ���������� ��� ���������� ������ ��� �������
                                           INNER JOIN ObjectBoolean AS ObjectBoolean_JuridicalArea_GoodsCode
                                                                    ON ObjectBoolean_JuridicalArea_GoodsCode.ObjectId  = Object_JuridicalArea.Id
                                                                   AND ObjectBoolean_JuridicalArea_GoodsCode.DescId    = zc_ObjectBoolean_JuridicalArea_GoodsCode()
                                                                   AND ObjectBoolean_JuridicalArea_GoodsCode.ValueData = TRUE
                                      WHERE ObjectLink_JuridicalArea_Juridical.ChildObjectId = inJuridicalId
                                        AND ObjectLink_JuridicalArea_Juridical.DescId        = zc_ObjectLink_JuridicalArea_Juridical()
                                     )
                    THEN inAreaId
                    ELSE 0
               END;

    -- ����� "�����" �� "�������"
    SELECT Id INTO vbLoadPriceListId
    FROM LoadPriceList
    WHERE JuridicalId = inJuridicalId AND OperDate = CURRENT_DATE AND COALESCE (ContractId, 0) = inContractId AND COALESCE (AreaId, 0) = COALESCE (inAreaId, 0);

    -- ���� ��� "�����" - ��������
    IF COALESCE (vbLoadPriceListId, 0) = 0
    THEN
         INSERT INTO LoadPriceList (JuridicalId, ContractId, AreaId, OperDate, NDSinPrice/*, UserId_Insert*/, Date_Insert)
         VALUES (inJuridicalId, inContractId, inAreaId, CURRENT_DATE, inNDSinPrice/*, inUserId*/, CURRENT_TIMESTAMP)
         RETURNING Id INTO vbLoadPriceListId;
    ELSE
         -- ����� ������� ��� ��� ���� ���������
         UPDATE LoadPriceList SET isMoved = FALSE, Date_Update = CURRENT_TIMESTAMP WHERE Id = vbLoadPriceListId;
         /*-- ����� � �������� ������� ��� ���� Insert
         UPDATE LoadPriceList SET UserId_Insert = inUserId, Date_Insert = CURRENT_TIMESTAMP WHERE Id = vbLoadPriceListId;*/
    END IF;

    -- ���� �� ������ ����
    WITH tmpCommonCode AS
    (
        SELECT
            tmpGoods.GoodsId,
            tmpGoods.isSpecCondition,
            tmpGoods.CommonCode

        FROM (WITH tmp AS (SELECT ObjectLink_LinkGoods_GoodsMain.ChildObjectId AS GoodsId
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
                          )
              SELECT ObjectLink_LinkGoods_GoodsMain.ChildObjectId AS GoodsId
                   , tmp.isSpecCondition
                   , Object_Goods.ObjectCode AS CommonCode
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
                   LEFT JOIN tmp ON tmp.GoodsId = ObjectLink_LinkGoods_GoodsMain.ChildObjectId
                   INNER JOIN
                    (SELECT DISTINCT inCommonCode FROM tblJSON)
                                         AS tblJSON
                                         ON Object_Goods.ObjectCode = tblJSON.inCommonCode
              WHERE Object_Goods.DescId = zc_Object_Goods() and tblJSON.inCommonCode > 0
             ) AS tmpGoods
    )
    UPDATE tblJSON
    SET GoodsID = tmpCommonCode.GoodsID,
        isSpecCondition = tmpCommonCode.isSpecCondition
    FROM tmpCommonCode
    WHERE inCommonCode = tmpCommonCode.CommonCode;

    -- ���� ����� ���� ���������� � ����� � ���������� ���������� ��� ����������
    WITH tmpGoodsCode AS
    (SELECT DISTINCT
           LoadPriceListItem.CommonCode
         , LoadPriceListItem.GoodsCode
    FROM LoadPriceListItem
    WHERE LoadPriceListItem.LoadPriceListId = vbLoadPriceListId
      AND COALESCE (LoadPriceListItem.CommonCode, 0) <> 0
      AND (LoadPriceListItem.GoodsCode <> '0' AND COALESCE(LoadPriceListItem.GoodsCode, '') <> '')
    )
    UPDATE tblJSON
      SET inGoodsCode = tmpGoodsCode.GoodsCode
    FROM tmpGoodsCode
    WHERE inCommonCode = tmpGoodsCode.CommonCode AND inCommonCode > 0
      AND (tblJSON.inGoodsCode = '0' or COALESCE(tblJSON.inGoodsCode, '') = '');

    -- ������� � �������� ������ ���������� �� ������� ����
    DELETE FROM tblJSON
    WHERE tblJSON.inGoodsCode = '0' or COALESCE(tblJSON.inGoodsCode, '') = '';

    -- ���� �� ���������
    WITH tmpBarCode AS
    (
        SELECT ObjectLink_LinkGoods_GoodsMain.ChildObjectId AS GoodsId
                   , ObjectBoolean_Goods_SpecCondition.ValueData  AS isSpecCondition
                   , Object_Goods.ValueData AS BarCode
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
             INNER JOIN
                (SELECT DISTINCT inBarCode
                    FROM tblJSON
                    WHERE inBarCode <> '' AND COALESCE(GoodsID, 0) = 0)
                                   AS tblJSON
                                   ON Object_Goods.ValueData = tblJSON.inBarCode
        WHERE Object_Goods.DescId = zc_Object_Goods()
    )
    UPDATE tblJSON
    SET GoodsID = tmpBarCode.GoodsID,
        isSpecCondition = tmpBarCode.isSpecCondition
    FROM tmpBarCode
    WHERE inBarCode = tmpBarCode.BarCode;


    -- ���� �� ���� � inJuridicalId
    WITH tmpGoodsCode AS
    (
        SELECT ObjectLink_LinkGoods_GoodsMain.ChildObjectId AS GoodsId
                 , ObjectBoolean_Goods_SpecCondition.ValueData  AS isSpecCondition
                 , ObjectString.ValueData as GoodsCode
                 , ROW_NUMBER() OVER(PARTITION BY ObjectString.ValueData ORDER BY ObjectLink_LinkGoods_GoodsMain.ChildObjectId DESC) as ORD
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

               LEFT JOIN ObjectLink AS ObjectLink_Goods_Area
                                    ON ObjectLink_Goods_Area.ObjectId = ObjectString.ObjectId
                                   AND ObjectLink_Goods_Area.DescId   = zc_ObjectLink_Goods_Area()
               INNER JOIN
                    (SELECT DISTINCT inGoodsCode
                        FROM tblJSON
                        WHERE COALESCE(GoodsID, 0) = 0 and tblJSON.inGoodsCode <> '0' and COALESCE(tblJSON.inGoodsCode, '') <> '')
                                   AS tblJSON
                                   ON ObjectString.ValueData = tblJSON.inGoodsCode

          WHERE ObjectString.DescId    = zc_ObjectString_Goods_Code()
            AND (-- ���� ������ ������������
                 COALESCE (ObjectLink_Goods_Area.ChildObjectId, 0) = vbAreaId_find
                 -- ��� ��� ������ zc_Area_Basis - ����� ���� � ������� "�����"
              OR (vbAreaId_find = zc_Area_Basis() AND ObjectLink_Goods_Area.ChildObjectId IS NULL)
                 -- ��� ��� ������ "�����" - ����� ���� � ������� zc_Area_Basis
              OR (vbAreaId_find = 0 AND ObjectLink_Goods_Area.ChildObjectId = zc_Area_Basis())
                )
            AND ObjectLink_LinkGoods_GoodsMain.ChildObjectId IN (SELECT Object.id FROM Object WHERE iserased = False)
    )
    UPDATE tblJSON
    SET GoodsID = tmpGoodsCode.GoodsID,
        isSpecCondition = tmpGoodsCode.isSpecCondition
    FROM tmpGoodsCode
    WHERE inGoodsCode = tmpGoodsCode.GoodsCode AND tblJSON.inGoodsCode <> '0' and COALESCE(tblJSON.inGoodsCode, '') <> '' AND ORD = 1;

    -- !!!������ ���������!!!
    UPDATE tblJSON
    SET inExpirationDate = zc_DateEnd()
    WHERE inExpirationDate IS NULL OR inExpirationDate = CURRENT_DATE;

    --!!!��������!!!
    IF EXISTS(SELECT * FROM tblJSON WHERE IsSpecCondition = TRUE)
       AND
       (SELECT COUNT(DISTINCT ObjectFloat_ConditionalPercent.ValueData)
        FROM ObjectFloat AS ObjectFloat_ConditionalPercent
        WHERE ObjectFloat_ConditionalPercent.ObjectId = inJuridicalId
          AND ObjectFloat_ConditionalPercent.DescId = zc_ObjectFloat_Juridical_ConditionalPercent()) > 1
    THEN
        RAISE EXCEPTION '�� ���������� <%> ����� ������ ���. ������� �� ������', inJuridicalId;
    END IF;

    SELECT ObjectFloat_ConditionalPercent.ValueData
    INTO vbConditionalPercent
    FROM ObjectFloat AS ObjectFloat_ConditionalPercent
    WHERE ObjectFloat_ConditionalPercent.ObjectId = inJuridicalId
      AND ObjectFloat_ConditionalPercent.DescId = zc_ObjectFloat_Juridical_ConditionalPercent();

    --!!!����� - ���������!!!
    IF inPriceNum = 0 THEN
        UPDATE tblJSON
        SET PriceOriginal = inPrice;
    ELSIF inPriceNum = 1 THEN
        UPDATE tblJSON
        SET PriceOriginal = inPrice1,
            inPrice = inPrice1;
    ELSIF inPriceNum = 2 THEN
        UPDATE tblJSON
        SET PriceOriginal = inPrice2,
            inPrice = inPrice2;
    ELSIF inPriceNum = 3 THEN
        UPDATE tblJSON
        SET PriceOriginal = inPrice3,
            inPrice = inPrice3;
    END IF;

    --!!!����� - ������!!!
    IF COALESCE(vbConditionalPercent, 0) <> 0 THEN

        UPDATE tblJSON
        SET inPrice = (inPrice * (1 + vbConditionalPercent / 100))::NUMERIC (16, 2)
        WHERE IsSpecCondition = TRUE;

    END IF;

    -- ������� ������� ����
    DELETE FROM tblJSON
    WHERE COALESCE(inPrice, 0) = 0;

    -- ��������� ������
    UPDATE LoadPriceListItem
    SET GoodsName = inGoodsName, CommonCode = inCommonCode, BarCode = COALESCE(inBarCode, ''), CodeUKTZED = COALESCE(inCodeUKTZED, ''), GoodsNDS = inGoodsNDS, GoodsId = tblJSON.GoodsId,
        Price = inPrice, PriceOriginal = tblJSON.PriceOriginal, ExpirationDate = inExpirationDate, PackCount = COALESCE(inPackCount, ''), ProducerName = COALESCE(inProducerName, '')
      , Remains = tblJSON.inRemains
    FROM tblJSON
    WHERE LoadPriceListId = vbLoadPriceListId AND GoodsCode = inGoodsCode AND COALESCE(CommonCode, 0) = COALESCE(inCommonCode) AND COALESCE (inPrice, 0) <> 0;


    -- ��������� �����
    INSERT INTO LoadPriceListItem (LoadPriceListId, CommonCode, BarCode, CodeUKTZED, GoodsCode, GoodsName, GoodsNDS, GoodsId, Price, PriceOriginal, ExpirationDate, PackCount, ProducerName, Remains)
    /*
    SELECT LoadPriceListId, inCommonCode, inBarCode, inCodeUKTZED, inGoodsCode, inGoodsName, inGoodsNDS, GoodsId, inPrice, PriceOriginal, inExpirationDate, inPackCount, inProducerName
    FROM
    (
        SELECT
            vbLoadPriceListId as LoadPriceListId, inCommonCode, COALESCE(inBarCode, '') as inBarCode, COALESCE(inCodeUKTZED, '') as inCodeUKTZED, inGoodsCode, inGoodsName, inGoodsNDS, GoodsId,
            inPrice, PriceOriginal, inExpirationDate, COALESCE(inPackCount, '') as inPackCount, COALESCE(inProducerName, '') as inProducerName,
            ROW_NUMBER() OVER(PARTITION BY GoodsId ORDER BY inExpirationDate, inCommonCode DESC) as RN
        FROM tblJSON
        WHERE COALESCE (inPrice, 0) <> 0 AND NOT EXISTS(SELECT * FROM LoadPriceListItem WHERE LoadPriceListId = vbLoadPriceListId AND GoodsCode = inGoodsCode)
    ) T
    WHERE RN = 1;
    */
    SELECT
        vbLoadPriceListId as LoadPriceListId, inCommonCode, COALESCE(inBarCode, '') as inBarCode, COALESCE(inCodeUKTZED, '') as inCodeUKTZED, inGoodsCode, inGoodsName, inGoodsNDS, GoodsId,
        inPrice, PriceOriginal, inExpirationDate, COALESCE(inPackCount, '') as inPackCount, COALESCE(inProducerName, '') as inProducerName
      , tblJSON.inRemains
    FROM tblJSON
    WHERE COALESCE (inPrice, 0) <> 0 AND NOT EXISTS(SELECT * FROM LoadPriceListItem WHERE LoadPriceListId = vbLoadPriceListId AND GoodsCode = inGoodsCode AND COALESCE(CommonCode, 0) = COALESCE(inCommonCode));

END;
$BODY$
LANGUAGE plpgsql VOLATILE;

ALTER FUNCTION lpInsertUpdate_Movement_LoadPriceList_JSON (Integer, Integer, Integer, Boolean, Text, Integer, Integer) OWNER TO postgres;