DROP FUNCTION IF EXISTS gpSelect_Movement_CheckVIP(Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_CheckVIP(
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (
  Id Integer, 
  InvNumber TVarChar, 
  OperDate TDateTime, 
  StatusId Integer,
  StatusCode Integer, 
  TotalCount TFloat, 
  TotalSumm TFloat, 
  UnitName TVarChar, 
  CashRegisterName TVarChar,
  CashMemberId Integer,
  CashMember TVarCHar,
  Bayer TVarChar,
  BayerPhone TVarChar,
  InvNumberOrder TVarChar,
  ConfirmedKindName TVarChar,
  ConfirmedKindClientName TVarChar,
  DiscountExternalId Integer,
  DiscountExternalName TVarChar,
  DiscountCardNumber TVarChar,
  Color_CalcDoc Integer
 )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);

     vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
     IF vbUnitKey = '' THEN
        vbUnitKey := '0';
     END IF;   
     vbUnitId := vbUnitKey::Integer;

     RETURN QUERY
       WITH
            tmpRemains AS(SELECT Container.ObjectId                  AS GoodsId
                               , SUM(Container.Amount)::TFloat       AS Amount
                          FROM Container
                          WHERE Container.DescId = zc_Container_Count()
                            AND Container.WhereObjectId = vbUnitId
                            AND Container.Amount <> 0
                          GROUP BY Container.ObjectId
                          )
          , tmpMov AS(SELECT Movement.Id
                      FROM Movement
                        INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                                   ON MovementBoolean_Deferred.MovementId = Movement.Id
                                                  AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                        INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                       WHERE Movement.DescId = zc_Movement_Check()
                         AND (Movement.StatusId = zc_Enum_Status_UnComplete()
                             OR
                             (Movement.StatusId = zc_Enum_Status_Erased() AND inIsErased = TRUE)) 
                         AND MovementBoolean_Deferred.ValueData = True 
                         AND (MovementLinkObject_Unit.ObjectId = vbUnitId OR vbUnitId = 0)
                       )
      , tmpColor AS (SELECT DISTINCT tmpMov.Id
                     FROM tmpMov
                          INNER JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKind
                                                        ON MovementLinkObject_ConfirmedKind.MovementId = tmpMov.Id
                                                       AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()
                                                       AND MovementLinkObject_ConfirmedKind.ObjectId = zc_Enum_ConfirmedKind_UnComplete()
                          INNER JOIN MovementItem 
                                  ON MovementItem.MovementId = tmpMov.Id
                                 AND MovementItem.DescId     = zc_MI_Master()
                                 AND MovementItem.isErased   = FALSE
                          LEFT JOIN tmpRemains ON tmpRemains.GoodsId = MovementItem.ObjectId
                     WHERE tmpRemains.Amount < MovementItem.Amount
                     )
         
       SELECT Movement.Id
            , Movement.InvNumber
            , Movement.OperDate
            , Movement.StatusId
            , Object_Status.ObjectCode                   AS StatusCode
            , MovementFloat_TotalCount.ValueData         AS TotalCount
            , MovementFloat_TotalSumm.ValueData          AS TotalSumm
            , Object_Unit.ValueData                      AS UnitName
            , Object_CashRegister.ValueData              AS CashRegisterName
            , MovementLinkObject_CheckMember.ObjectId    AS CashMemberId
            , CASE WHEN MovementString_InvNumberOrder.ValueData <> '' AND COALESCE (Object_CashMember.ValueData, '') = '' THEN zc_Member_Site() ELSE Object_CashMember.ValueData END :: TVarChar AS CashMember
	    , MovementString_Bayer.ValueData             AS Bayer

            , MovementString_BayerPhone.ValueData        AS BayerPhone
            , MovementString_InvNumberOrder.ValueData    AS InvNumberOrder
            , Object_ConfirmedKind.ValueData             AS ConfirmedKindName
            , Object_ConfirmedKindClient.ValueData       AS ConfirmedKindClientName

	    , Object_DiscountExternal.Id                 AS DiscountExternalId
	    , Object_DiscountExternal.ValueData          AS DiscountExternalName
	    , Object_DiscountCard.ValueData              AS DiscountCardNumber

            , CASE WHEN Object_ConfirmedKind.Id = zc_Enum_ConfirmedKind_UnComplete() AND COALESCE (tmpColor.Id, 0) <> 0 THEN 16440317 -- 
                   WHEN Object_ConfirmedKind.Id = zc_Enum_ConfirmedKind_UnComplete() AND COALESCE (tmpColor.Id, 0) = 0  THEN zc_Color_Yelow() -- ������
                   ELSE zc_Color_White()
             END  AS Color_CalcDoc

       FROM tmpMov
            LEFT JOIN Movement ON Movement.Id = tmpMov.Id 
                               
                              
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                        
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

   	    INNER JOIN MovementBoolean AS MovementBoolean_Deferred
		                       ON MovementBoolean_Deferred.MovementId = Movement.Id
		                      AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
				      
            LEFT JOIN MovementLinkObject AS MovementLinkObject_CashRegister
                                         ON MovementLinkObject_CashRegister.MovementId = Movement.Id
                                        AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()
            LEFT JOIN Object AS Object_CashRegister ON Object_CashRegister.Id = MovementLinkObject_CashRegister.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckMember
                                         ON MovementLinkObject_CheckMember.MovementId = Movement.Id
                                        AND MovementLinkObject_CheckMember.DescId = zc_MovementLinkObject_CheckMember()
  	    LEFT JOIN Object AS Object_CashMember ON Object_CashMember.Id = MovementLinkObject_CheckMember.ObjectId
  	    
            LEFT JOIN MovementLinkObject AS MovementLinkObject_DiscountCard
                                         ON MovementLinkObject_DiscountCard.MovementId = Movement.Id
                                        AND MovementLinkObject_DiscountCard.DescId = zc_MovementLinkObject_DiscountCard()
            LEFT JOIN ObjectLink AS ObjectLink_DiscountExternal
                                 ON ObjectLink_DiscountExternal.ObjectId = MovementLinkObject_DiscountCard.ObjectId
                                AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountCard_Object()
            LEFT JOIN Object AS Object_DiscountExternal ON Object_DiscountExternal.Id = ObjectLink_DiscountExternal.ChildObjectId
            LEFT JOIN Object AS Object_DiscountCard ON Object_DiscountCard.Id = MovementLinkObject_DiscountCard.ObjectId

	    LEFT JOIN MovementString AS MovementString_Bayer
                                     ON MovementString_Bayer.MovementId = Movement.Id
                                    AND MovementString_Bayer.DescId = zc_MovementString_Bayer()
             LEFT JOIN MovementString AS MovementString_BayerPhone
                                      ON MovementString_BayerPhone.MovementId = Movement.Id
                                     AND MovementString_BayerPhone.DescId = zc_MovementString_BayerPhone()

             LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                      ON MovementString_InvNumberOrder.MovementId = Movement.Id
                                     AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()
             LEFT JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKind
                                          ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                         AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()
             LEFT JOIN Object AS Object_ConfirmedKind ON Object_ConfirmedKind.Id = MovementLinkObject_ConfirmedKind.ObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKindClient
                                          ON MovementLinkObject_ConfirmedKindClient.MovementId = Movement.Id
                                         AND MovementLinkObject_ConfirmedKindClient.DescId = zc_MovementLinkObject_ConfirmedKindClient()
             LEFT JOIN Object AS Object_ConfirmedKindClient ON Object_ConfirmedKindClient.Id = MovementLinkObject_ConfirmedKindClient.ObjectId
   
             LEFT JOIN tmpColor ON tmpColor.Id = Movement.Id
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_CheckVIP (Boolean, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 31.10.16         *
 10.08.16                                                                     * �����������
 07.04.16         * ���� �� �����
 12.09.2015                                                                   *[17:23] ������ �����: ������ ������ ������� � ���������� �� � ������ ���
 04.07.15                                                                     * 
*/

-- ����
-- SELECT * FROM gpSelect_Movement_CheckVIP (inIsErased := FALSE, inSession:= '3')
