-- Function: gpGet_Movement_Promo()

DROP FUNCTION IF EXISTS gpGet_Movement_Promo (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Promo(
    IN inMovementId        Integer  , -- ���� ���������
    IN inOperDate          TDateTime, -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id               Integer     --�������������
             , InvNumber        TVarChar    --����� ���������
             , OperDate         TDateTime   --���� ���������
             , StatusCode       Integer     --��� �������
             , StatusName       TVarChar    --������
             , PromoKindId      Integer     --��� �����
             , PromoKindName    TVarChar    --��� �����
             , PriceListId      Integer     --����� ����
             , PriceListName    TVarChar    --����� ����
             , StartPromo       TDateTime   --���� ������ �����
             , EndPromo         TDateTime   --���� ��������� �����
             , StartSale        TDateTime   --���� ������ �������� �� ��������� ����
             , EndSale          TDateTime   --���� ��������� �������� �� ��������� ����
             , OperDateStart    TDateTime   --���� ������ ����. ������ �� �����
             , OperDateEnd      TDateTime   --���� ��������� ����. ������ �� �����
             , CostPromo        TFloat      --��������� ������� � �����
             , Comment          TVarChar    --����������
             , CommentMain      TVarChar    --���������� (�����)
             , UnitId           INTEGER     --�������������
             , UnitName         TVarChar    --�������������
             , PersonalTradeId  INTEGER     --������������� ������������� ������������� ������
             , PersonalTradeName TVarChar   --������������� ������������� ������������� ������
             , PersonalId       INTEGER     --������������� ������������� �������������� ������	
             , PersonalName     TVarChar    --������������� ������������� �������������� ������	
             )
AS
$BODY$
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Promo());
    IF COALESCE (inMovementId, 0) = 0
    THEN
        RETURN QUERY
        SELECT
            0                                                 AS Id
          , CAST (NEXTVAL ('movement_Promo_seq') AS TVarChar) AS InvNumber
          , inOperDate				                          AS OperDate
          , Object_Status.Code               	              AS StatusCode
          , Object_Status.Name              		          AS StatusName
          , NULL::Integer                                     AS PromoKindId         --��� �����
          , NULL::TVarChar                                    AS PromoKindName       --��� �����
          , Object_PriceList.Id                               AS PriceListId         --����� ����
          , Object_PriceList.ValueData                        AS PriceListName       --����� ����
          , NULL::TDateTime                                   AS StartPromo          --���� ������ �����
          , NULL::TDateTime                                   AS EndPromo            --���� ��������� �����
          , NULL::TDateTime                                   AS StartSale           --���� ������ �������� �� ��������� ����
          , NULL::TDateTime                                   AS EndSale             --���� ��������� �������� �� ��������� ����
          , NULL::TDateTime                                   AS OperDateStart       --���� ������ ����. ������ �� �����
          , NULL::TDateTime                                   AS OperDateEnd         --���� ��������� ����. ������ �� �����
          , NULL::TFloat                                      AS CostPromo           --��������� ������� � �����
          , NULL::TVarChar                                    AS Comment             --����������
          , NULL::TVarChar                                    AS CommentMain         --���������� (�����)
          , NULL::Integer                                     AS UnitId              --�������������
          , NULL::TVarChar                                    AS UnitName            --�������������
          , NULL::Integer                                     AS PersonalTradeId     --������������� ������������� ������������� ������
          , NULL::TVarChar                                    AS PersonalTradeName   --������������� ������������� ������������� ������
          , NULL::Integer                                     AS PersonalId          --������������� ������������� �������������� ������	
          , NULL::TVarChar                                    AS PersonalName        --������������� ������������� �������������� ������	
        FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
            LEFT OUTER JOIN Object AS Object_PriceList ON Object_PriceList.Id = zc_PriceList_Basis();
    ELSE
        RETURN QUERY
        SELECT
            Movement_Promo.Id                 --�������������
          , Movement_Promo.InvNumber          --����� ���������
          , Movement_Promo.OperDate           --���� ���������
          , Movement_Promo.StatusCode         --��� �������
          , Movement_Promo.StatusName         --������
          , Movement_Promo.PromoKindId        --��� �����
          , Movement_Promo.PromoKindName      --��� �����
          , Movement_Promo.PriceListId        --��� �����
          , Movement_Promo.PriceListName      --��� �����
          , Movement_Promo.StartPromo         --���� ������ �����
          , Movement_Promo.EndPromo           --���� ��������� �����
          , Movement_Promo.StartSale          --���� ������ �������� �� ��������� ����
          , Movement_Promo.EndSale            --���� ��������� �������� �� ��������� ����
          , Movement_Promo.OperDateStart      --���� ������ ����. ������ �� �����
          , Movement_Promo.OperDateEnd        --���� ��������� ����. ������ �� �����
          , Movement_Promo.CostPromo          --��������� ������� � �����
          , Movement_Promo.Comment            --����������
          , Movement_Promo.Comment            --���������� (�����)
          , Movement_Promo.UnitId             --�������������
          , Movement_Promo.UnitName           --�������������
          , Movement_Promo.PersonalTradeId    --������������� ������������� ������������� ������
          , Movement_Promo.PersonalTradeName  --������������� ������������� ������������� ������
          , Movement_Promo.PersonalId         --������������� ������������� �������������� ������	
          , Movement_Promo.PersonalName       --������������� ������������� �������������� ������	
             
        FROM
            Movement_Promo_View AS Movement_Promo
        WHERE Movement_Promo.Id =  inMovementId;
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_Promo (Integer, TDateTime, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 13.10.15                                                                        *
*/
