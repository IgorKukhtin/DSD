-- Function: gpSelect_CheckItem_SPKind_1303()

DROP FUNCTION IF EXISTS gpSelect_CheckItem_SPKind_1303 (Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_CheckItem_SPKind_1303(
    IN inSPKindId            Integer   , -- ��� ������
    IN inGoodsId             Integer   , -- ������
    IN inPriceSale           TFloat    , -- ���� ��� ������
   OUT outError              TVarChar  , -- ���������
   OUT outError2             TVarChar  , -- ���������
   OUT outSentence           TVarChar  , -- ����������� �� ����
   OUT outPrice              TFloat    , -- ���������� ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS record
AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;

   DECLARE vbPriceCalc TFloat;
   DECLARE vbPersent   TFloat;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Sale());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;

    outError := '';
    outError2 := '';
    outSentence := '';
    outPrice := 0;
    
    -- �������� ������ �� ������ ���������� � ������� ��� 20%, ��� ����. 1303
    IF inSPKindId = zc_Enum_SPKind_1303()
    THEN 
            --
            IF EXISTS (SELECT 1 
                       FROM ObjectLink
                            INNER JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                                   ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink.ChildObjectId 
                                                  AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                                                  AND ObjectFloat_NDSKind_NDS.ValueData = 20
                       WHERE ObjectLink.ObjectId = inGoodsId
                         AND ObjectLink.DescId = zc_ObjectLink_Goods_NDSKind())
               THEN
                   outError := '������. ������ �� ������ ������ �� ���� 1303 �� ������� ���=20 ����.'||Chr(13)||Chr(10)||'(����� ��� ����������� !!!)';
                   RETURN;
            END IF;
            
            SELECT CASE WHEN tt.Price < 100 THEN tt.Price * 1.249
                         WHEN tt.Price >= 100 AND tt.Price < 500 THEN tt.Price * 1.199
                         WHEN tt.Price >= 500 AND tt.Price < 1000 THEN tt.Price * 1.149
                         WHEN tt.Price >= 1000 THEN tt.Price * 1.099
                    END :: TFloat AS PriceCalc
                  , CASE WHEN tt.Price < 100 THEN 25
                         WHEN tt.Price >= 100 AND tt.Price < 500 THEN 20
                         WHEN tt.Price >= 500 AND tt.Price < 1000 THEN 15
                         WHEN tt.Price >= 1000 THEN 10
                    END :: TFloat AS Persent
            INTO vbPriceCalc, vbPersent
             FROM (SELECT CASE WHEN MovementBoolean_PriceWithVAT.ValueData = TRUE THEN MIFloat_Price.ValueData
                               ELSE (MIFloat_Price.ValueData * (1 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData,1)/100))::TFloat    -- � ������ ��������������  ���� � ���, � ��������� ��� ���
                          END AS Price   -- ���� c ���
                        , ROW_NUMBER() OVER (ORDER BY Container.Id DESC) AS ord   -- ���� ������� �������� �� ��������� ������
                   FROM Container 
                      LEFT OUTER JOIN ContainerLinkObject AS CLI_MI 
                                                          ON CLI_MI.ContainerId = Container.Id
                                                         AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
                      LEFT OUTER JOIN OBJECT AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId

                      LEFT OUTER JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode :: Integer
                      LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                  ON MIFloat_Price.MovementItemId = MI_Income.Id
                                                 AND MIFloat_Price.DescId = zc_MIFloat_Price()

                      LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                ON MovementBoolean_PriceWithVAT.MovementId =  MI_Income.MovementId
                                               AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                      LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                   ON MovementLinkObject_NDSKind.MovementId = MI_Income.MovementId
                                                  AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                      LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                            ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId
                                           AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()

                   WHERE Container.ObjectId = inGoodsId
                     AND Container.DescId = zc_Container_Count()
                     AND Container.WhereObjectId = vbUnitId
                     AND COALESCE (Container.Amount,0 ) > 0
                     AND COALESCE (MIFloat_Price.ValueData ,0) > 0
                   ) AS tt
             WHERE tt.Ord = 1;

            -- ��������  ���� < 100��� � ����������� ���������� �������� ���� �������� 25%. �� 100 �� 500 ��� � �������� �� ��� 20%. ³� 500 �� 1000 � 15%. ����� 1000 ��� �������� �� ��� 10%.
            IF (COALESCE (vbPriceCalc,0) < inPriceSale) AND (COALESCE (vbPriceCalc,0) <> 0)
               THEN
                   IF vbPersent = 25 THEN  outError :=  '������. ������ �� ������ ������ �� ���� 1303 � �������� ����� 25 ���������'||Chr(13)||Chr(10)||'(��� ������ � ��������� ����� �� 100���)'; END IF;
                   IF vbPersent = 20 THEN  outError :=  '������. ������ �� ������ ������ �� ���� 1303 � �������� ����� 20 ���������'||Chr(13)||Chr(10)||'(��� ������ � ��������� ����� �� 100��� �� 500���)'; END IF;
                   IF vbPersent = 15 THEN  outError :=  '������. ������ �� ������ ������ �� ���� 1303 � �������� ����� 15 ���������'||Chr(13)||Chr(10)||'(��� ������ � ��������� ����� �� 500��� �� 1000���)'; END IF;
                   IF vbPersent = 10 THEN  outError :=  '������. ������ �� ������ ������ �� ���� 1303 � �������� ����� 10 ���������'||Chr(13)||Chr(10)||'(��� ������ � ��������� ����� ����� 1000���)'; END IF;
                   outError2 :=  Chr(13)||Chr(10)||'������� PrintScreen ������ � ������� � ��������� �� Skype ������ ��������� ���  ����������� ���� ����������'||Chr(13)||Chr(10)||'(����� ����������� - �������� ����� ��������� �� �������)';
            END IF;

            outPrice := trunc(vbPriceCalc * 10) / 10;
            
            -- ����������� �� ����
            IF (COALESCE (vbPriceCalc,0) < inPriceSale) AND (COALESCE (trunc(vbPriceCalc * 10) / 10, 0) > 0)
            THEN
                   outSentence :=  '��������� ����������� ���������� ���� - '||to_char(outPrice, 'G999G999G999G999D99');
            END IF;
    END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.    ��������� �.�.  ������ �.�.
 26.01.20                                                                                      *
*/

-- SELECT * FROM gpSelect_CheckItem_SPKind_1303(inSPKindId := zc_Enum_SPKind_1303(), inGoodsId := 499, inPriceSale := 1, inSession := '3');