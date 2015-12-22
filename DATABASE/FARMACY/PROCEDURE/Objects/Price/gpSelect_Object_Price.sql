-- Function: gpSelect_Object_Street (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Price(Integer, Boolean,Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Price(
    IN inUnitId      Integer,       -- �������������
    IN inisShowAll   Boolean,        --True - �������� ��� ������, False - �������� ������ � ������
    IN inisShowDel   Boolean,       --True - �������� ��� �� ���������, False - �������� ������ �������
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Price TFloat, MCSValue Tfloat
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , DateChange TDateTime, MCSDateChange TDateTime
             , MCSIsClose Boolean, MCSIsCloseDateChange TDateTime
             , MCSNotRecalc Boolean, MCSNotRecalcDateChange TDateTime
             , Fix Boolean, FixDateChange TDateTime
             , Remains TFloat, isErased boolean
             ) AS
$BODY$
DECLARE
    vbUserId Integer;
    vbObjectId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Street());
    vbUserId:= lpGetUserBySession (inSession);
    -- ����������� �� �������� ��������� �����������
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    IF inUnitId is null
    THEN
        inUnitId := 0;
    END IF;
    -- ���������
    IF COALESCE(inUnitId,0) = 0
    THEN
        RETURN QUERY
            SELECT 
                NULL::Integer                    AS Id
               ,NULL::TFloat                     AS Price
               ,NULL::TFloat                     AS MCSValue
               ,NULL::Integer                    AS GoodsId
               ,NULL::Integer                    AS GoodsCode
               ,NULL::TVarChar                   AS GoodsName
               ,NULL::TDateTime                  AS DateChange
               ,NULL::TDateTime                  AS MCSDateChange
               ,NULL::Boolean                    AS MCSIsClose
               ,NULL::TDateTime                  AS MCSIsCloseDateChange
               ,NULL::Boolean                    AS MCSNotRecalc
               ,NULL::TDateTime                  AS MCSNotRecalcDateChange
               ,NULL::Boolean                    AS Fix
               ,NULL::TDateTime                  AS FixDateChange
               ,NULL::TFloat                     AS Remains
               ,NULL::Boolean                    AS isErased
            WHERE 1=0;
    ELSEIF inisShowAll = True
    THEN
        RETURN QUERY
            SELECT
                Object_Price_View.Id                            AS Id
               ,Object_Price_View.Price                         AS Price 
               ,Object_Price_View.MCSValue                      AS MCSValue
               ,Object_Goods.id                                 AS GoodsId
               ,Object_Goods.ObjectCode                         AS GoodsCode
               ,object_goods.ValueData                          AS GoodsName
               ,Object_Price_View.DateChange                    AS DateChange
               ,Object_Price_View.MCSDateChange                 AS MCSDateChange
               ,COALESCE(Object_Price_View.MCSIsClose,False)    AS MCSIsClose
               ,Object_Price_View.MCSIsCloseDateChange          AS MCSIsCloseDateChange
               ,COALESCE(Object_Price_View.MCSNotRecalc,False)  AS MCSNotRecalc
               ,Object_Price_View.MCSNotRecalcDateChange        AS MCSNotRecalcDateChange
               ,COALESCE(Object_Price_View.Fix,False)           AS Fix
               ,Object_Price_View.FixDateChange                 AS FixDateChange
               ,Object_Remains.Remains                          AS Remains
               ,Object_Goods.isErased                           AS isErased 
            FROM Object AS Object_Goods
                INNER JOIN ObjectLink ON Object_Goods.Id = ObjectLink.ObjectId
                                     AND ObjectLink.ChildObjectId = vbObjectId
                LEFT OUTER JOIN Object_Price_View ON Object_Goods.id = object_price_view.goodsid
                                                 AND Object_Price_View.unitid = inUnitId
                LEFT OUTER JOIN (
                                    SELECT 
                                        container.objectid,
                                        SUM(Amount)::TFloat AS Remains
                                    FROM container
                                        INNER JOIN containerlinkobject AS CLO_Unit
                                                                       ON CLO_Unit.containerid = container.id 
                                                                      AND CLO_Unit.descid = zc_ContainerLinkObject_Unit()
                                                                      AND CLO_Unit.objectid = inUnitId
                                    WHERE 
                                        container.descid = zc_container_count() 
                                        AND 
                                        Amount<>0
                                    GROUP BY 
                                        container.objectid
                                ) AS Object_Remains
                                  ON Object_Remains.ObjectId = Object_Goods.Id
            WHERE
                Object_Goods.DescId = zc_Object_Goods()
                AND
                (
                    inisShowDel = True
                    OR
                    Object_Goods.isErased = False
                )
            ORDER BY
                GoodsName;
    ELSE
        RETURN QUERY
            SELECT
                Object_Price_View.Id                     AS Id
               ,Object_Price_View.Price                  AS Price 
               ,Object_Price_View.MCSValue               AS MCSValue
               ,Object_Goods.id                          AS GoodsId
               ,Object_Goods.ObjectCode                  AS GoodsCode
               ,object_goods.ValueData                   AS GoodsName
               ,Object_Price_View.DateChange             AS DateChange
               ,Object_Price_View.MCSDateChange          AS MCSDateChange
               ,Object_Price_View.MCSIsClose             AS MCSIsClose
               ,Object_Price_View.MCSIsCloseDateChange   AS MCSIsCloseDateChange
               ,Object_Price_View.MCSNotRecalc           AS MCSNotRecalc
               ,Object_Price_View.MCSNotRecalcDateChange AS MCSNotRecalcDateChange
               ,Object_Price_View.Fix                    AS Fix
               ,Object_Price_View.FixDateChange          AS FixDateChange
               ,Object_Remains.Remains                   AS Remains
               ,Object_Goods.isErased                    AS isErased 
            FROM Object_Price_View
                LEFT OUTER JOIN Object AS Object_Goods ON Object_Goods.id = object_price_view.goodsid
                LEFT OUTER JOIN (
                                    SELECT 
                                        container.objectid,
                                        SUM(Amount)::TFloat AS Remains
                                    FROM container
                                        INNER JOIN containerlinkobject AS CLO_Unit
                                                                       ON CLO_Unit.containerid = container.id 
                                                                      AND CLO_Unit.descid = zc_ContainerLinkObject_Unit()
                                                                      AND CLO_Unit.objectid = inUnitId
                                    WHERE 
                                        container.descid = zc_container_count() 
                                        AND 
                                        Amount<>0
                                    GROUP BY 
                                        container.objectid
                                ) AS Object_Remains
                                  ON Object_Remains.ObjectId = Object_Price_View.GoodsId
            WHERE
                Object_Price_View.unitid = inUnitId
                AND
                (
                    inisShowDel = True
                    OR
                    Object_Goods.isErased = False
                )
            ORDER BY
                GoodsName;
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Price(Integer, Boolean,Boolean,TVarChar) OWNER TO postgres;
/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�. 
 22.12.15                                                         *
 29.08.15                                                         * + MCSIsClose, MCSNotRecalc
 09.06.15                        *

*/

-- ����
-- SELECT * FROM gpSelect_Object_Price (183292,True,False,'3');