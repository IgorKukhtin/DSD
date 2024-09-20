-- Function: gpSelect_Movement_PromoTrade_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_PromoTrade_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_PromoTrade_Print(
    IN inMovementId        Integer  , -- ���� ���������
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;

    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbOperDate TDateTime;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PromoTrade());
     vbUserId:= lpGetUserBySession (inSession);


     -- ��������� �� ���������
     SELECT Movement.DescId
          , Movement.StatusId
          , Movement.OperDate
            INTO vbDescId, vbStatusId, vbOperDate
     FROM Movement
     WHERE Movement.Id = inMovementId;

  /*
     -- ����� ������ ��������
     IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete() AND vbUserId <> 5 -- !!!����� ������!!!
     THEN
         IF vbStatusId = zc_Enum_Status_Erased()
         THEN
             RAISE EXCEPTION '������.�������� <%> � <%> �� <%> ������.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
         END IF;
         IF vbStatusId = zc_Enum_Status_UnComplete()
         THEN
             RAISE EXCEPTION '������.�������� <%> � <%> �� <%> �� ��������.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
         END IF;
         -- ��� ��� �������� ������
         RAISE EXCEPTION '������.�������� <%>.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId);
     END IF;
  */

    CREATE TEMP TABLE _tmpMI ON COMMIT DROP AS
      SELECT tmp.*
      FROM gpSelect_MovementItem_PromoTradeGoods (inMovementId, FALSE, inSession) AS tmp;

     --               
     OPEN Cursor1 FOR
      WITH
       tmpMovement AS (SELECT tmp.*
                       FROM  gpGet_Movement_PromoTrade (inMovementId, vbOperDate, FALSE, inSession) AS tmp
                       )

        SELECT
            1 ::Integer AS LineNo,
            '������'::TVarChar as LineName,
            (SELECT tmpMovement.RetailName
             FROM tmpMovement)::TEXT AS LineValue
        UNION ALL
        SELECT
            2 ::Integer AS LineNo,
            '�������� �����'::TVarChar as LineName,
            (SELECT tmpMovement.JuridicalName
             FROM tmpMovement)::TEXT AS LineValue
        UNION ALL
        SELECT
            3 ::Integer AS LineNo,
            '������� �����, ���'::TVarChar as LineName,
            (SELECT tmpMovement.CostPromo
             FROM tmpMovement)::TEXT AS LineValue
        UNION ALL
        SELECT
            4 ::Integer AS LineNo,
            '����� �����'::TVarChar as LineName,
            (SELECT TO_CHAR(tmpMovement.StartPromo, 'DD.MM.YYYY')||' - '||TO_CHAR(tmpMovement.EndPromo, 'DD.MM.YYYY')
             FROM tmpMovement)::TEXT AS LineValue
        UNION ALL
        SELECT
            5 ::Integer AS LineNo,
            '����� �����'::TVarChar as LineName,
            (SELECT tmpMovement.PromoKindName
             FROM tmpMovement)::TEXT AS LineValue
        UNION ALL
        SELECT
            6 ::Integer AS LineNo,
            'ʳ������ SKU'::TVarChar as LineName,
            (SELECT COUNT(_tmpMI.GoodsCode) 
             FROM _tmpMI)::TEXT AS LineValue
        UNION ALL
        SELECT
            7 ::Integer AS LineNo,
            'ʳ������ �������� �����'::TVarChar as LineName,
            (SELECT SUM (_tmpMI.PartnerCount)
             FROM _tmpMI)::TEXT AS LineValue
        UNION ALL
        SELECT
            8 ::Integer AS LineNo,
            '������� �����'::TVarChar as LineName,
            (SELECT STRING_AGG (CASE WHEN _tmpMI.TradeMarkName <> '' THEN _tmpMI.TradeMarkName || ' ' ELSE '' END , chr(13)) 
             FROM _tmpMI)::TEXT AS LineValue
        UNION ALL
        SELECT
            9 ::Integer AS LineNo,
            '����������'::TVarChar as LineName,
            '��������'::TEXT AS LineValue
        UNION ALL
        SELECT
            10 ::Integer AS LineNo,
            '�������� ��''�� ������� � �����, ��'::TVarChar as LineName,
            (SELECT CAST (SUM (_tmpMI.AmountSale / 3) AS NUMERIC (16,2))
             FROM _tmpMI)::TEXT AS LineValue
        UNION ALL
        SELECT
            11 ::Integer AS LineNo,
            '�������� ��''�� ������� � �����, ���'::TVarChar as LineName,
            (SELECT CAST (SUM (_tmpMI.SummSale / 3) AS NUMERIC (16,2))
             FROM _tmpMI)::TEXT AS LineValue
        UNION ALL
        SELECT
            12 ::Integer AS LineNo,
            '����� ��������'::TVarChar as LineName,
            '' :: TEXT AS LineValue
        UNION ALL
        SELECT
            13 ::Integer AS LineNo,
            '��������� ��''�� ������� � �����, ��'::TVarChar as LineName,
            (SELECT CAST (SUM (_tmpMI.AmountSale / 3) AS NUMERIC (16,2))
             FROM _tmpMI)::TEXT AS LineValue
        UNION ALL
        SELECT
            14 ::Integer AS LineNo,
            '��������� ��''�� ������� � �����, ���'::TVarChar as LineName,
            (SELECT CAST (SUM (_tmpMI.SummSale / 3) AS NUMERIC (16,2))
             FROM _tmpMI)::TEXT AS LineValue
        UNION ALL
        SELECT
            15 ::Integer AS LineNo,
            '% ���������'::TVarChar as LineName,
            (SELECT CAST (CASE WHEN COALESCE (_tmpMI.AmountSale,0) <> 0 THEN _tmpMI.AmountReturnIn * 100 / _tmpMI.AmountSale ELSE 0 END AS NUMERIC (16,1))
             FROM _tmpMI)::TEXT AS LineValue
        UNION ALL
        SELECT
            16 ::Integer AS LineNo,
            '���������� ���������� ��������������, ���'::TVarChar as LineName,
            ('')::TEXT AS LineValue
      ;
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
       WITH
       tmpGoodsQuality AS (SELECT ObjectLink_Goods.ChildObjectId AS GoodsId
                                , CAST (CASE WHEN POSITION( '���' IN ObjectString_Value2.ValueData) > 0 THEN CAST(LEFT (ObjectString_Value2.ValueData,POSITION( '���' IN ObjectString_Value2.ValueData)-1 ) AS NUMERIC (16,0) ) / 24
                                             WHEN POSITION( '��' IN ObjectString_Value2.ValueData) > 0 THEN CAST(LEFT (ObjectString_Value2.ValueData,POSITION( '��' IN ObjectString_Value2.ValueData)-1 ) AS NUMERIC (16,0) )
                                             WHEN POSITION( '���' IN ObjectString_Value2.ValueData) > 0 THEN CAST(LEFT (ObjectString_Value2.ValueData,POSITION( '���' IN ObjectString_Value2.ValueData)-1 ) AS NUMERIC (16,0) )
                                             WHEN POSITION( '��' IN ObjectString_Value2.ValueData) > 0 THEN CAST(LEFT (ObjectString_Value2.ValueData,POSITION( '��' IN ObjectString_Value2.ValueData)-1 ) AS NUMERIC (16,0) ) * 30
                                             WHEN POSITION( '���' IN ObjectString_Value2.ValueData) > 0 THEN CAST(LEFT (ObjectString_Value2.ValueData,POSITION( '���' IN ObjectString_Value2.ValueData)-1 ) AS NUMERIC (16,0) ) * 364
                                        ELSE 0
                                        END AS NUMERIC (16,0) ) + 1 AS Value2   -- ���� �������� � ����
                           FROM ObjectBoolean AS ObjectBoolean_Klipsa
                                INNER JOIN Object AS Object_GoodsQuality 
                                                  ON Object_GoodsQuality.Id = ObjectBoolean_Klipsa.ObjectId
                                                 AND Object_GoodsQuality.isErased = FALSE
                                LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                     ON ObjectLink_Goods.ObjectId = ObjectBoolean_Klipsa.ObjectId
                                                    AND ObjectLink_Goods.DescId = zc_ObjectLink_GoodsQuality_Goods()

                                LEFT JOIN ObjectString AS ObjectString_Value2
                                                       ON ObjectString_Value2.ObjectId = Object_GoodsQuality.Id 
                                                      AND ObjectString_Value2.DescId = zc_ObjectString_GoodsQuality_Value2()
                           WHERE ObjectBoolean_Klipsa.DescId = zc_ObjectBoolean_GoodsQuality_Klipsa()
                             AND ObjectBoolean_Klipsa.ValueData = TRUE
                           )

       SELECT tmpMI.Ord     
            , Object_GoodsGroup.ValueData AS GoodsGroupName
            , tmpMI.TradeMarkName 
            , tmpMI.GoodsCode
            , tmpMI.GoodsName
            , tmpMI.GoodsKindName
            , tmpMI.MeasureName
            , tmpMI.Amount
            , tmpMI.Summ
       FROM _tmpMI AS tmpMI
            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpMI.GoodsId
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
       WHERE tmpMI.Amount <> 0
       ;
    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.09.24         *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_PromoTrade_Print (inMovementId := 29301131, inSession:= zfCalc_UserAdmin())
