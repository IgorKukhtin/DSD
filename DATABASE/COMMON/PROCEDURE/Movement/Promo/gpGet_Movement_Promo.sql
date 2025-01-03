-- Function: gpGet_Movement_Promo()

--DROP FUNCTION IF EXISTS gpGet_Movement_Promo (Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_Promo (Integer, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Promo(
    IN inMovementId        Integer  , -- ���� ���������
    IN inOperDate          TDateTime, -- ���� ���������
    IN inMask              Boolean  , -- �������� �� �����
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id               Integer     --�������������
             , InvNumber        Integer    --����� ���������
             , InvNumberFull    TVarChar   --����� ��������� + ����
             , OperDate         TDateTime   --���� ���������
             , StatusCode       Integer     --��� �������
             , StatusName       TVarChar    --������     
             , PaidKindId Integer, PaidKindName TVarChar
             , PromoKindId      Integer     --��� �����
             , PromoKindName    TVarChar    --��� �����
             , PromoStateKindId Integer     -- ��������� �����
             , PromoStateKindName TVarChar  -- ��������� �����
             , PriceListId      Integer     --����� ����
             , PriceListName    TVarChar    --����� ����
             , StartPromo       TDateTime   --���� ������ �����
             , EndPromo         TDateTime   --���� ��������� �����
             , StartSale        TDateTime   --���� ������ �������� �� ��������� ����
             , EndSale          TDateTime   --���� ��������� �������� �� ��������� ����
             , EndReturn        TDateTime   --���� ��������� ��������� �� ��������� ����
             , OperDateStart    TDateTime   --���� ������ ����. ������ �� �����
             , OperDateEnd      TDateTime   --���� ��������� ����. ������ �� �����
             , MonthPromo       TDateTime   --����� �����
             , CheckDate        TDateTime   --���� ������������  
             , ServiceDate      TDateTime   --����� ������� �/�
             , CostPromo        TFloat      --��������� ������� � �����
             , ChangePercent    TFloat      --(-)% ������ (+)% ������� �� ��������

             , Comment          TVarChar    --����������
             , CommentMain      TVarChar    --���������� (�����)
             , UnitId           INTEGER     --�������������
             , UnitName         TVarChar    --�������������
             , PersonalTradeId  INTEGER     --������������� ������������� ������������� ������
             , PersonalTradeName TVarChar   --������������� ������������� ������������� ������
             , PersonalId       INTEGER     --������������� ������������� �������������� ������	
             , PersonalName     TVarChar    --������������� ������������� �������������� ������	
             , SignInternalId   Integer
             , SignInternalName TVarChar
             , isPromo          Boolean     --����� (��/���)   
             , isCost           Boolean     --�������
             , Checked          Boolean     --����������� (��/���)
             , isTaxPromo       Boolean     -- ����� % ������
             , isTaxPromo_Condition  Boolean     -- ����� % �����������
             , isPromoStateKind   Boolean      -- ��������� ��� ���������
             , strSign          TVarChar    -- ��� �������������. - ���� ��. �������
             , strSignNo        TVarChar    -- ��� �������������. - ��������� ��. ������� 
             
             , OperDateOrder_text TVarChar
             )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbSignInternalId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Promo());
    -- vbUserId:= lpGetUserBySession (inSession);

    --IF NOT EXISTS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId
     -- ������� ��� �� �����
     IF COALESCE (inMask, False) = True
     THEN
     inMovementId := gpInsert_Movement_Promo_Mask (ioId        := inMovementId
                                                 , inOperDate  := inOperDate
                                                 , inSession   := inSession); 
     END IF;

    IF COALESCE (inMovementId, 0) < 0
    THEN
        RAISE EXCEPTION '������. ���������� ������� ������ ��������.';
    END IF;


    IF COALESCE (inMovementId, 0) = 0
    THEN
        -- ������ �� ������ ��� ������� ���������
        vbSignInternalId := (SELECT DISTINCT tmp.SignInternalId
                             FROM lpSelect_Object_SignInternalItem ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_SignInternal())
                                                                  , (SELECT Movement.DescId FROM Movement WHERE Movement.Id = inMovementId)
                                                                  , 0, 0) AS tmp
                            );
        -- ���������
        RETURN QUERY
        SELECT
            0                                                 AS Id
          , CAST (NEXTVAL ('movement_Promo_seq') AS Integer)  AS InvNumber
          , ''  :: TVarChar                                   AS InvNumberFull
          , inOperDate	                                      AS OperDate
          , Object_Status.Code                                AS StatusCode
          , Object_Status.Name                                AS StatusName 
          , NULL::Integer                                     AS PaidKindId
          , NULL::TVarChar                                    AS PaidKindName
          , NULL::Integer                                     AS PromoKindId         --��� �����
          , NULL::TVarChar                                    AS PromoKindName       --��� �����
          , 0                                                 AS PromoStateKindId        --��������� �����
          , NULL::TVarChar                                    AS PromoStateKindName      --��������� �����

          , Object_PriceList.Id                               AS PriceListId         --����� ����
          , Object_PriceList.ValueData                        AS PriceListName       --����� ����
          , NULL::TDateTime                                   AS StartPromo          --���� ������ �����
          , NULL::TDateTime                                   AS EndPromo            --���� ��������� �����
          , NULL::TDateTime                                   AS StartSale           --���� ������ �������� �� ��������� ����
          , NULL::TDateTime                                   AS EndSale             --���� ��������� �������� �� ��������� ����
          , NULL::TDateTime                                   AS EndReturn           --���� ��������� ��������� �� ��������� ����
          , NULL::TDateTime                                   AS OperDateStart       --���� ������ ����. ������ �� �����
          , NULL::TDateTime                                   AS OperDateEnd         --���� ��������� ����. ������ �� �����
          , NULL::TDateTime                                   AS MonthPromo          --����� ����� 
          , inOperDate                                        AS CheckDate           --���� ������������
          , NULL:: TDateTime                                  AS ServiceDate
          , NULL::TFloat                                      AS CostPromo           --��������� ������� � �����
          , NULL::TFloat                                      AS ChangePercent       --(-)% ������ (+)% ������� �� ��������
          , NULL::TVarChar                                    AS Comment             --����������
          , NULL::TVarChar                                    AS CommentMain         --���������� (�����)
          , NULL::Integer                                     AS UnitId              --�������������
          , NULL::TVarChar                                    AS UnitName            --�������������
          , NULL::Integer                                     AS PersonalTradeId     --������������� ������������� ������������� ������
          , NULL::TVarChar                                    AS PersonalTradeName   --������������� ������������� ������������� ������
          , NULL::Integer                                     AS PersonalId          --������������� ������������� �������������� ������	
          , NULL::TVarChar                                    AS PersonalName        --������������� ������������� �������������� ������
          , Object_SignInternal.Id                            AS SignInternalId
          , Object_SignInternal.ValueData :: TVarChar         AS SignInternalName
             
          , CAST (TRUE  AS Boolean)                           AS isPromo
          , CAST (FALSE AS Boolean)                           AS isCost
          , CAST (FALSE AS Boolean)                           AS Checked
          , CAST (FALSE AS Boolean)                           AS isTaxPromo            -- ����� % ������
          , CAST (FALSE AS Boolean)                           AS isTaxPromo_Condition  -- ����� % �����������
          , CAST (FALSE AS Boolean)                           AS isPromoStateKind  -- ��������� ��� ���������
          , NULL::TVarChar                                    AS strSign
          , NULL::TVarChar                                    AS strSignNo
          , NULL::TVarChar                                    AS OperDateOrder_text 
        FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
            LEFT OUTER JOIN Object AS Object_PriceList ON Object_PriceList.Id = zc_PriceList_Basis()
            LEFT JOIN Object AS Object_SignInternal ON Object_SignInternal.Id = vbSignInternalId
        ;
    ELSE
        RETURN QUERY
        WITH
        tmpOperDateOrder AS (SELECT STRING_AGG (DISTINCT CASE WHEN COALESCE (ObjectBoolean_OperDateOrder.ValueData, FALSE ) = TRUE THEN  '������' ELSE '��������' END , ';') AS OperDateOrder_text
                             FROM Movement AS Movement_Promo 
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                              ON MovementLinkObject_Partner.MovementId = Movement_Promo.Id
                                                             AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()

                                 LEFT OUTER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                            ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_Partner.ObjectId
                                                           AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

                                 LEFT OUTER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                            ON ObjectLink_Juridical_Retail.ObjectId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_Partner.ObjectId)
                                                           AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()

                                 LEFT JOIN ObjectBoolean AS ObjectBoolean_OperDateOrder
                                                         ON ObjectBoolean_OperDateOrder.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                                        AND ObjectBoolean_OperDateOrder.DescId = zc_ObjectBoolean_Retail_OperDateOrder()

                             WHERE Movement_Promo.DescId = zc_Movement_PromoPartner()
                               AND Movement_Promo.ParentId = inMovementId
                             ) 

        SELECT
            Movement_Promo.Id                 --�������������
          , Movement_Promo.InvNumber          --����� ���������
          , ('� ' || Movement_Promo.InvNumber || ' �� ' || zfConvert_DateToString (Movement_Promo.OperDate)  ) :: TVarChar AS InvNumberFull
          , Movement_Promo.OperDate           --���� ���������
          , Movement_Promo.StatusCode         --��� �������
          , Movement_Promo.StatusName         --������  
          , Movement_Promo.PaidKindId        --
          , Movement_Promo.PaidKindName        --
          , Movement_Promo.PromoKindId        --��� �����
          , Movement_Promo.PromoKindName      --��� �����
          , Movement_Promo.PromoStateKindId   --��������� �����
          , Movement_Promo.PromoStateKindName --��������� �����
          , Movement_Promo.PriceListId        --
          , Movement_Promo.PriceListName      --
          , Movement_Promo.StartPromo         --���� ������ �����
          , Movement_Promo.EndPromo           --���� ��������� �����
          , Movement_Promo.StartSale          --���� ������ �������� �� ��������� ����
          , Movement_Promo.EndSale            --���� ��������� �������� �� ��������� ����
          , Movement_Promo.EndReturn          --���� ��������� ��������� �� ��������� ����
          , Movement_Promo.OperDateStart      --���� ������ ����. ������ �� �����
          , Movement_Promo.OperDateEnd        --���� ��������� ����. ������ �� �����
          , Movement_Promo.MonthPromo         -- ����� �����
          , Movement_Promo.CheckDate          --���� ������������    
          , Movement_Promo.ServiceDate        --����� ������� �/�
          , Movement_Promo.CostPromo          --��������� ������� � �����
          , Movement_Promo.ChangePercent      --(-)% ������ (+)% ������� �� ��������
          , Movement_Promo.Comment            --����������
          , Movement_Promo.CommentMain        --���������� (�����)
          , Movement_Promo.UnitId             --�������������
          , Movement_Promo.UnitName           --�������������
          , Movement_Promo.PersonalTradeId    --������������� ������������� ������������� ������
          , Movement_Promo.PersonalTradeName  --������������� ������������� ������������� ������
          , Movement_Promo.PersonalId         --������������� ������������� �������������� ������	
          , Movement_Promo.PersonalName       --������������� ������������� �������������� ������
          , COALESCE (Movement_Promo.SignInternalId, Object_SignInternal.Id)          AS SignInternalId
          , COALESCE (Movement_Promo.SignInternalName, Object_SignInternal.ValueData) AS SignInternalName
          , Movement_Promo.isPromo            --�����
          , Movement_Promo.isCost                   --�������
          , Movement_Promo.Checked            --�����������
          , Movement_Promo.isTaxPromo
          , Movement_Promo.isTaxPromo_Condition
          , Movement_Promo.isPromoStateKind :: Boolean AS isPromoStateKind  -- ��������� ��� ���������

          , tmpSign.strSign
          , tmpSign.strSignNo  
          
          , tmpOperDateOrder.OperDateOrder_text ::TVarChar           
        FROM Movement_Promo_View AS Movement_Promo
             LEFT JOIN lpSelect_MI_Sign (inMovementId:= Movement_Promo.Id ) AS tmpSign ON tmpSign.Id = Movement_Promo.Id   -- ��.�������  --
             LEFT JOIN Object AS Object_SignInternal ON Object_SignInternal.Id = tmpSign.SignInternalId
             LEFT JOIN tmpOperDateOrder ON 1 = 1
        WHERE Movement_Promo.Id =  inMovementId
        LIMIT 1;

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 01.05.23         *
 07.05.21         * add inMask
 13.07.20         * ChangePercent
 01.04.20         *
 01.08.17         * CheckedDate
 25.07.17         *
 13.10.15                                                                        *
*/

-- ����
-- SELECT * FROM gpGet_Movement_Promo (inMovementId:= 1, inOperDate:= '30.11.2015', inMask:= False, inSession:= zfCalc_UserAdmin())
--select * from gpGet_Movement_Promo(inMovementId := 29044450 , inOperDate := ('01.11.2024')::TDateTime , inMask := 'False' ,  inSession := '9457');