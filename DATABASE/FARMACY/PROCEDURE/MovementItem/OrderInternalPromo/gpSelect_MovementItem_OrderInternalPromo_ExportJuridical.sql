-- Function: gpSelect_MovementItem_OrderInternalPromo_ExportJuridical()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderInternalPromo_ExportJuridical (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_OrderInternalPromo_ExportJuridical(
    IN inMovementId  Integer      , -- ���� ���������
    IN inSession     TVarChar       -- ������ ������������
)

RETURNS TABLE (JuridicalId  Integer
)

AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbError Text;

BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderExternal());
     vbUserId := inSession;

    -- ��������
    IF NOT EXISTS(SELECT 1
                  FROM (SELECT T1.Id, T1.JuridicalId
                        FROM gpSelect_MI_OrderInternalPromo(inMovementId := inMovementId , inIsErased := 'False' ,  inSession := inSession) AS T1
                        WHERE T1.JuridicalId in (59611, 59610, 59612, 183353, 410822, 183319, 183332)
                          AND T1.Amount > 0) AS tmpOrderInternal 
                       INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                              AND MovementItem.DescId = zc_MI_Child()
                                              AND MovementItem.isErased = FALSE
                                              AND MovementItem.ParentId = tmpOrderInternal.Id
                                              AND MovementItem.Amount > 0) 
    THEN
       RAISE EXCEPTION '��� ������ ��� ��������.';
    END IF;

    -- ��������
    IF EXISTS(SELECT T1.Id
              FROM gpSelect_MI_OrderInternalPromo(inMovementId := inMovementId , inIsErased := 'False' ,  inSession := inSession) AS T1
                                       
                   LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = T1.GoodsId
                   LEFT JOIN Object_Goods_Juridical ON Object_Goods_Juridical.GoodsMainId = Object_Goods_Retail.GoodsMainId
                                                    AND Object_Goods_Juridical.JuridicalId = T1.JuridicalId

              WHERE T1.Amount > 0
                AND COALESCE(Object_Goods_Juridical.GoodsMainId, 0) = 0) 
    THEN
      SELECT string_agg(Chr(13)||'���������: '||T1.JuridicalName||Chr(13)||''||T1.GoodsName, Chr(13))
      INTO vbError
      FROM gpSelect_MI_OrderInternalPromo(inMovementId := inMovementId , inIsErased := 'False' ,  inSession := inSession) AS T1
                                       
           LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = T1.GoodsId
           LEFT JOIN Object_Goods_Juridical ON Object_Goods_Juridical.GoodsMainId = Object_Goods_Retail.GoodsMainId
                                            AND Object_Goods_Juridical.JuridicalId = T1.JuridicalId

      WHERE T1.Amount > 0
        AND COALESCE(Object_Goods_Juridical.GoodsMainId, 0) = 0;
    
       RAISE EXCEPTION '��� ������ ���������� ��������:%', vbError;
    END IF;

     
     -- ���������
     RETURN QUERY
     SELECT DISTINCT tmpOrderInternal.JuridicalId
     FROM (SELECT T1.Id, T1.JuridicalId
           FROM gpSelect_MI_OrderInternalPromo(inMovementId := inMovementId , inIsErased := 'False' ,  inSession := inSession) AS T1
           WHERE T1.JuridicalId in (59611, 59610, 59612, 183353, 410822, 183319, 183332)
             AND T1.Amount > 0) AS tmpOrderInternal 
          INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                 AND MovementItem.DescId = zc_MI_Child()
                                 AND MovementItem.isErased = FALSE
                                 AND MovementItem.ParentId = tmpOrderInternal.Id
                                 AND MovementItem.Amount > 0;
                                 
   
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_OrderInternalPromo_ExportJuridical (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 08.08.21                                                       *

*/

-- ����
-- 
select * from gpSelect_MovementItem_OrderInternalPromo_ExportJuridical(inMovementId := 29739305 ,  inSession := '3');