-- Function: gpInsertUpdate_Object_Goods_Retail()

DROP FUNCTION IF EXISTS lpInsertUpdate_Goods_CountPrice (Integer, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Goods_CountPrice(
    IN inPriceListId         Integer    ,    -- ���� ��������� <����� ����>
    IN inOperDate            TDateTime  ,    -- ��� ������� <���� ������>
    IN inGoodsId             Integer        -- �����
)
RETURNS Void
AS
$BODY$
   DECLARE vbAreaId     Integer;
   DECLARE vbStartDate  TDateTime;
   DECLARE vbEndDate    TDateTime;
BEGIN
     vbStartDate:= DATE_TRUNC ('DAY', inOperDate);
     vbEndDate:=   DATE_TRUNC ('DAY', inOperDate) + INTERVAL '1 DAY';
     
     vbAreaId := 0;--COALESCE ((SELECT COALESCE (LoadPriceList.AreaId, 0) FROM LoadPriceList WHERE LoadPriceList.Id = inPriceListId), 0);

     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpDataCount'))
     THEN
         DROP TABLE _tmpDataCount;
     END IF;

     CREATE TEMP TABLE _tmpDataCount (GoodsId Integer, CountPrice  TFloat) ON COMMIT DROP;
     INSERT INTO _tmpDataCount (GoodsId, CountPrice)
            WITH
            -- �������� ������� ��� �����
            /*tmpRetail AS (SELECT DISTINCT ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
                               , ObjectLink_Unit_Area.ChildObjectId                 AS AreaId
                          FROM Object AS Object_Unit
                              INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                   ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                                  AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                              INNER JOIN ObjectLink AS ObjectLink_Unit_Area
                                                   ON ObjectLink_Unit_Area.ObjectId = Object_Unit.Id 
                                                  AND ObjectLink_Unit_Area.DescId = zc_ObjectLink_Unit_Area()
                                                     AND COALESCE ( ObjectLink_Unit_Area.ChildObjectId, 0) <> 0
                              INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                   ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                  AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                  AND COALESCE (ObjectLink_Juridical_Retail.ChildObjectId, 0) <> 0
                          WHERE Object_Unit.DescId = zc_Object_Unit()
                            AND Object_Unit.isErased = False
                            AND (COALESCE (ObjectLink_Unit_Area.ChildObjectId, 0) = vbAreaId OR vbAreaId = 0)
                          )
          -- ������ ���� �� �������� ������, ��� ������� ����� �������� ��������
          , */tmpGoods AS (SELECT DISTINCT ObjectLink_Goods_Object1.ObjectId AS GoodsId -- ����� ����
                             -- , tmpRetail.AreaId                           AS AreaId
                              , Object_Retail.Id                           AS RetailId
                         FROM  ObjectLink AS ObjectLink_Main_R  
                               -- ����� � ����� ���� ...
                              INNER JOIN ObjectLink AS ObjectLink_Child_R 
                                                    ON ObjectLink_Child_R.ObjectId = ObjectLink_Main_R.ObjectId
                                                   AND ObjectLink_Child_R.DescId   = zc_ObjectLink_LinkGoods_Goods()
                              --�������� ����
                              INNER JOIN ObjectLink AS ObjectLink_Goods_Object1
                                                    ON ObjectLink_Goods_Object1.ObjectId = ObjectLink_Child_R.ChildObjectId
                                                   AND ObjectLink_Goods_Object1.DescId = zc_ObjectLink_Goods_Object()
                              INNER JOIN Object AS Object_Retail
                                                ON Object_Retail.Id = ObjectLink_Goods_Object1.ChildObjectId
                                               AND Object_Retail.DescId = zc_Object_Retail()
                             -- INNER JOIN tmpRetail ON tmpRetail.RetailId = Object_Retail.Id 
                         WHERE ObjectLink_Main_R.ChildObjectId = inGoodsId
                           AND ObjectLink_Main_R.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                         )
          -- ������� ���-�� ����������
          , tmpCount AS (SELECT COALESCE (MovementLinkObject_Area.ObjectId, 0)  AS AreaId
                              , Count (Movement.Id)                             AS CountPrice
                         FROM Movement 
                              INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                     AND MovementItem.DescId   = zc_MI_Master()
                                                     AND MovementItem.isErased = FALSE
                                                     AND MovementItem.ObjectId = inGoodsId --333 --inGoodsId
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_Area
                                                           ON MovementLinkObject_Area.MovementId = Movement.Id
                                                          AND MovementLinkObject_Area.DescId = zc_MovementLinkObject_Area()
                         WHERE Movement.OperDate >= vbStartDate AND Movement.OperDate < vbEndDate
       	            AND Movement.DescId = zc_Movement_PriceList()
       	            AND Movement.StatusId <> zc_Enum_Status_Erased()
                           AND Movement.Id <> inPriceListId
                           AND (COALESCE (MovementLinkObject_Area.ObjectId, 0) = vbAreaId OR COALESCE (MovementLinkObject_Area.ObjectId, 0) = 0 OR vbAreaId=0)
                         GROUP BY  COALESCE (MovementLinkObject_Area.ObjectId, 0)
                        )

         SELECT tmp.GoodsId, SUM (tmp.CountPrice) AS CountPrice
         FROM (SELECT tmpGoods.GoodsId, tmpCount.CountPrice
               FROM tmpGoods
                    INNER JOIN (SELECT DISTINCT ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
                                     , ObjectLink_Unit_Area.ChildObjectId                 AS AreaId
                                FROM Object AS Object_Unit
                                    INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                         ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                                        AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                    INNER JOIN ObjectLink AS ObjectLink_Unit_Area
                                                         ON ObjectLink_Unit_Area.ObjectId = Object_Unit.Id 
                                                        AND ObjectLink_Unit_Area.DescId = zc_ObjectLink_Unit_Area()
                                                           AND COALESCE ( ObjectLink_Unit_Area.ChildObjectId, 0) <> 0
                                    INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                         ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                        AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                        AND COALESCE (ObjectLink_Juridical_Retail.ChildObjectId, 0) <> 0
                                WHERE Object_Unit.DescId = zc_Object_Unit()
                                  AND Object_Unit.isErased = False
                                  AND (COALESCE (ObjectLink_Unit_Area.ChildObjectId, 0) = vbAreaId OR vbAreaId = 0)
                                ) AS tmpRetail ON tmpRetail.RetailId = tmpGoods.RetailId

                    LEFT JOIN tmpCount ON (tmpCount.AreaId = tmpRetail.AreaId)
                    
               WHERE COALESCE (tmpCount.AreaId, 0) <> 0
               UNION ALL
               SELECT tmpGoods.GoodsId, tmpCount.CountPrice
               FROM tmpGoods
                    LEFT JOIN tmpCount ON ( COALESCE (tmpCount.AreaId, 0) =0)
               WHERE COALESCE (tmpCount.AreaId, 0) = 0
               ) AS tmp
         GROUP BY tmp.GoodsId;
   
   -- ���������� �������� ���-�� ������� ������ ����
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_CountPrice(), _tmpDataCount.GoodsId, COALESCE (_tmpDataCount.CountPrice, 0) + 1)
   FROM _tmpDataCount;
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.02.18         *
 21.04.17         *
*/
-- ����
-- SELECT * FROM lpInsertUpdate_Goods_CountPrice

