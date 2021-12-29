-- Function: gpSelect_ShowPUSH_PartionGoodsDate_CalculateOrderInternal(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_ShowPUSH_PartionGoodsDate_CalculateOrderInternal(integer,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ShowPUSH_PartionGoodsDate_CalculateOrderInternal(
    IN inMovementID   integer,          -- ��������
   OUT outShowMessage Boolean,          -- ��������� ���������
   OUT outPUSHType    Integer,          -- ��� ���������
   OUT outText        Text,             -- ����� ���������
    IN inSession      TVarChar          -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbStatusId  Integer;
   DECLARE vbUnitId    Integer;
   DECLARE vbText      Text;
   DECLARE vbDate180 TDateTime;
BEGIN

    vbUserId:= lpGetUserBySession (inSession);

    outShowMessage := False;
    
     -- ���������
    SELECT Movement.StatusId, MovementLinkObject_Unit.ObjectId
    INTO vbStatusId, vbUnitId
    FROM Movement
         LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
    WHERE Movement.Id = inMovementId;
    
    vbDate180 := CURRENT_DATE + zc_Interval_ExpirationDate()+ zc_Interval_ExpirationDate();   -- ����� 1 ��� (������� =6 ���.)

    WITH
        tmpMI_All AS (SELECT MovementItem.GoodsId,
                             MovementItem.CalcAmountAll, 
                             MovementItem.JuridicalId, 
                             MovementItem.PartionGoodsDate,
                             MovementItem.Comment,
                             MovementItem.ListDiffAmount
                      FROM gpSelect_MovementItem_OrderInternal_Master(inMovementId := inMovementID , inShowAll := 'False' , inIsErased := 'False' , inIsLink := 'False' ,  inSession := inSession) AS MovementItem 


                      WHERE MovementItem.CalcAmountAll > 0
                      ),
        tmpNTZ AS (SELECT string_agg(Object_Goods_Main.ObjectCode||' - '||Object_Goods_Main.Name||Chr(13)||
                                     '   ���� �������� : '||zfConvert_DateShortToString (tmpMI_All.PartionGoodsDate)||' '|| COALESCE(tmpMI_All.Comment, ''), Chr(13)) AS Goods
                   FROM tmpMI_All

                        INNER JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = tmpMI_All.GoodsId
                         
                        INNER JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
                         
                   WHERE tmpMI_All.PartionGoodsDate < vbDate180
                     AND COALESCE (tmpMI_All.ListDiffAmount, 0) = 0),
        tmpListDiff AS (SELECT string_agg(Object_Goods_Main.ObjectCode||' - '||Object_Goods_Main.Name||Chr(13)||
                                          '   ���� �������� : '||zfConvert_DateShortToString (tmpMI_All.PartionGoodsDate)||' '|| COALESCE(tmpMI_All.Comment, ''), Chr(13)) AS Goods
                        FROM tmpMI_All

                             INNER JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = tmpMI_All.GoodsId
                               
                             INNER JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
                               
                        WHERE tmpMI_All.PartionGoodsDate < vbDate180
                          AND COALESCE (tmpMI_All.ListDiffAmount, 0) > 0)
                          
    SELECT COALESCE (Chr(13)||Chr(13)||'�� ���������� �� ���:'||Chr(13)||tmpNTZ.Goods, '')||
           COALESCE (Chr(13)||Chr(13)||'��  ����� ������:'||Chr(13)||tmpListDiff.Goods, '')
    INTO vbText
    FROM tmpNTZ
         
         FULL JOIN tmpListDiff ON 1 = 1;
         
         
    --raise notice 'Value: %', vbText;
    
    IF COALESCE (vbText, '') > ''
    THEN
      outShowMessage := True;
      outPUSHType := zc_TypePUSH_Confirmation();
      outText := '� ������� ���� �������� ����� 1 ����:'||vbText;
    END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 28.12.21                                                       *

*/

-- SELECT * FROM gpSelect_ShowPUSH_PartionGoodsDate_CalculateOrderInternal(22749117, '3')

select * from gpSelect_ShowPUSH_PartionGoodsDate_CalculateOrderInternal(inMovementID := 26210458  ,  inSession := '3');