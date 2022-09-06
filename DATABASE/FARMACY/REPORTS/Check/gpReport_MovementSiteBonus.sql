--  gpReport_MovementSiteBonus()

DROP FUNCTION IF EXISTS gpReport_MovementSiteBonus (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_MovementSiteBonus(
    IN inShowAll       Boolean  , --
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (BuyerForSiteId         Integer
             , BuyerForSiteCode       Integer
             , BuyerForSiteName       TVarChar
             , Phone                  TVarChar
             , Bonus                  TFloat
             , Bonus_Used             TFloat
             , MobileDiscount         TFloat
             , MobileDiscount_Compl   TFloat
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
   vbUserId:= lpGetUserBySession (inSession);

     -- ���������
   RETURN QUERY
   SELECT Object_BuyerForSite.Id
        , Object_BuyerForSite.ObjectCode
        , Object_BuyerForSite.ValueData
        , ObjectString_BuyerForSite_Phone.ValueData            AS Phone
        , SUM(MovementSiteBonus.Bonus)::TFloat                 AS Bonus
        , SUM(MovementSiteBonus.Bonus_Used)::TFloat            AS Bonus_Used
        , SUM(MovementFloat_MobileDiscount.ValueData)::TFloat  AS MobileDiscount
        , SUM(CASE WHEN Movement.StatusId = zc_Enum_Status_Complete() THEN MovementFloat_MobileDiscount.ValueData END)::TFloat  AS MobileDiscount_Compl
   FROM MovementSiteBonus

        LEFT JOIN Object AS Object_BuyerForSite 
                         ON Object_BuyerForSite.DescId = zc_Object_BuyerForSite()
                        AND Object_BuyerForSite.ObjectCode = MovementSiteBonus.BuyerForSiteCode
                        
        LEFT JOIN ObjectString AS ObjectString_BuyerForSite_Phone
                               ON ObjectString_BuyerForSite_Phone.ObjectId = Object_BuyerForSite.Id 
                              AND ObjectString_BuyerForSite_Phone.DescId = zc_ObjectString_BuyerForSite_Phone()

        LEFT JOIN Movement ON Movement.Id = MovementSiteBonus.MovementId
        
        LEFT JOIN MovementFloat AS MovementFloat_MobileDiscount
                                ON MovementFloat_MobileDiscount.MovementId =  Movement.Id
                               AND MovementFloat_MobileDiscount.DescId = zc_MovementFloat_MobileDiscount()
                         
   GROUP BY Object_BuyerForSite.Id
          , Object_BuyerForSite.ObjectCode
          , Object_BuyerForSite.ValueData
          , ObjectString_BuyerForSite_Phone.ValueData 
   HAVING SUM(MovementSiteBonus.Bonus) <> 0 OR SUM(MovementSiteBonus.Bonus_Used) <> 0 OR inShowAll = True;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.  ������ �.�.
 29.07.21                                                                                    *
*/

-- ����
-- 


select * from gpReport_MovementSiteBonus(inShowAll := True ,  inSession := '3');