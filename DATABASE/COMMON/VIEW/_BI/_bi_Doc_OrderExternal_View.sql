-- View: _bi_Doc_OrderExternal_View

DROP VIEW IF EXISTS _bi_Doc_OrderExternal_View;

/*
-- �������� - ������ ���������
-- ������:
  --�������� ������ ���������
Id
InvNumber
OperDate 
--��� �������
StatusCode
StatusName
--���� �������� �����������
OperDatePartner
--���� ����������
OperDateMark
--����� ������ � �����������
InvNumberPartner
--������������� (������ ������) / ����������
FromId
FromName
--������������� (������ ������) / �������������
ToId
ToName
--���������� ����(����������)
PersonalId
PersonalName
--�������
RouteId
RouteName 
--���������� ���������
RouteSortingId
RouteSortingName
--���� ���� ������ 
PaidKindId
PaidKindName
--�������
ContractId
ContractCode
ContractName
ContractTagName
--�����-����
PriceListId
PriceListName
--����������
PartnerId
PartnerName
--�������� ����
RetailId
RetailName
--���������� �� ��������
CarInfoId
CarInfoName
--���������� � ��������
CarComment
--����/����� ��������
OperDate_CarInfo
--���� � ��� (��/���)
PriceWithVAT
--��� �� ���������� �������� (��/���)
isPrinted
--�������� ���������� � ��������� ���������
isPrintComment
--% ���
VATPercent
--(-)% ������ (+)% �������
ChangePercent
--����� ����� �� ��������� (��� ���)
TotalSummMVAT
--����� ����� �� ��������� (� ���)
TotalSummPVAT
--����� ����� �� ��������� (� ������ ��� � ������)
TotalSumm
--����� ����������, ��
TotalCountKg
--����� ����������, ��
TotalCountSh
--����� ����������
TotalCount
--����� ���������� �������
TotalCountSecond
--�������� EDI
MovementId_EDI
--��� ����������� ������
IsRemains
--���� �� ������ � ������ � ���������
isPromo
--�������� �����
MovementPromo
--�����������
Comment
--� ������������
InsertName
--� ����/����� �������� ���������
InsertDate
--� ����/����� �������� �� ��� ����.
InsertMobileDate
--� ���������� ���������� �������������
GUID
--�������� ����/����� ������
StartBegin
--�������� ����/����� ����������
EndBegin
--���� �������� wms
StatusId_wms
StatusCode_wms
StatusName_wms

-- Id ������
MovementItemId
--������� ������ (��/���)
isErased_mi
--�����
GoodsId
--��� ������
GoodsKindId
--����������
Amount
--����
Price
--���� �� �������
PriceEDI
--���� �� ����������
CountForPrice
--(-)% ������ (+)% �������
ChangePercent_mi
--���������� �������
AmountSecond
--����� � ��� � �������
Summ
--MovementId-�����
MovementId_Promo
--�������� ����/����� ������
StartBegin_mi
--�������� ����/����� ����������
EndBegin_mi
*/


CREATE OR REPLACE VIEW _bi_Doc_OrderExternal_View
AS

       SELECT
             Movement.Id                                    AS Id
           , Movement.InvNumber                             AS InvNumber
           , Movement.OperDate                              AS OperDate 
           --��� �������
           , Object_Status.ObjectCode                       AS StatusCode
           , Object_Status.ValueData                        AS StatusName
           --���� �������� �����������
           , MovementDate_OperDatePartner.ValueData         AS OperDatePartner
           --���� ����������
           , MovementDate_OperDateMark.ValueData            AS OperDateMark
           --����� ������ � �����������
           , MovementString_InvNumberPartner.ValueData      AS InvNumberPartner
           --������������� (������ ������) / ����������
           , Object_From.Id                                 AS FromId
           , Object_From.ValueData                          AS FromName
           --������������� (������ ������) / �������������
           , Object_To.Id                                   AS ToId
           , Object_To.ValueData                            AS ToName
           --���������� ����(����������)
           , Object_Personal.Id                             AS PersonalId
           , Object_Personal.ValueData                      AS PersonalName
           --�������
           , Object_Route.Id                                AS RouteId
           , Object_Route.ValueData                         AS RouteName 
           --���������� ���������
           , Object_RouteSorting.Id                         AS RouteSortingId
           , Object_RouteSorting.ValueData                  AS RouteSortingName
           --���� ���� ������ 
           , Object_PaidKind.Id                             AS PaidKindId
           , Object_PaidKind.ValueData                      AS PaidKindName
           --�������
           , View_Contract_InvNumber.ContractId             AS ContractId
           , View_Contract_InvNumber.ContractCode           AS ContractCode
           , View_Contract_InvNumber.InvNumber              AS ContractName
           , View_Contract_InvNumber.ContractTagName        AS ContractTagName
           --�����-����
           , Object_PriceList.id                            AS PriceListId
           , Object_PriceList.ValueData                     AS PriceListName
           --����������
           , Object_Partner.id                              AS PartnerId
           , Object_Partner.ValueData                       AS PartnerName
           --�������� ����
           , Object_Retail.Id                               AS RetailId
           , Object_Retail.ValueData                        AS RetailName
           --���������� �� ��������
           , Object_CarInfo.Id                              AS CarInfoId
           , Object_CarInfo.ValueData                       AS CarInfoName
           --���������� � ��������
           , MovementString_CarComment.ValueData ::TVarChar AS CarComment
           --����/����� ��������
           , MovementDate_CarInfo.ValueData     ::TDateTime AS OperDate_CarInfo
           --���� � ��� (��/���)
           , MovementBoolean_PriceWithVAT.ValueData         AS PriceWithVAT
           --��� �� ���������� �������� (��/���)
           , COALESCE (MovementBoolean_Print.ValueData, False) AS isPrinted
           --�������� ���������� � ��������� ���������
           , COALESCE (MovementBoolean_PrintComment.ValueData, FALSE) AS isPrintComment
           --% ���
           , MovementFloat_VATPercent.ValueData             AS VATPercent
           --(-)% ������ (+)% �������
           , MovementFloat_ChangePercent.ValueData          AS ChangePercent
           --����� ����� �� ��������� (��� ���)
           , MovementFloat_TotalSummMVAT.ValueData          AS TotalSummMVAT
           --����� ����� �� ��������� (� ���)
           , MovementFloat_TotalSummPVAT.ValueData          AS TotalSummPVAT
           --����� ����� �� ��������� (� ������ ��� � ������)
           , MovementFloat_TotalSumm.ValueData              AS TotalSumm
           --����� ����������, ��
           , MovementFloat_TotalCountKg.ValueData           AS TotalCountKg
           --����� ����������, ��
           , MovementFloat_TotalCountSh.ValueData           AS TotalCountSh
           --����� ����������
           , MovementFloat_TotalCount.ValueData             AS TotalCount
           --����� ���������� �������
           , MovementFloat_TotalCountSecond.ValueData       AS TotalCountSecond
           --�������� EDI
           , MovementLinkMovement_Order.MovementId          AS MovementId_EDI
           --��� ����������� ������
           , COALESCE (MovementBoolean_Remains.ValueData, FALSE) ::Boolean AS IsRemains
           --���� �� ������ � ������ � ���������
           , COALESCE (MovementBoolean_Promo.ValueData, FALSE) AS isPromo
           --�������� �����
           , zfCalc_PromoMovementName (NULL, Movement_Promo.InvNumber :: TVarChar, Movement_Promo.OperDate, MD_StartSale.ValueData, MD_EndSale.ValueData) AS MovementPromo
           --�����������
           , MovementString_Comment.ValueData       AS Comment
           --� ������������
           , Object_User.ValueData                  AS InsertName
           --� ����/����� �������� ���������
           , MovementDate_Insert.ValueData          AS InsertDate
           --� ����/����� �������� �� ��� ����.
           , MovementDate_InsertMobile.ValueData    AS InsertMobileDate
           --� ���������� ���������� �������������
           , MovementString_GUID.ValueData :: TVarChar AS GUID
           --�������� ����/����� ������
           , MovementDate_StartBegin.ValueData  AS StartBegin
           --�������� ����/����� ����������
           , MovementDate_EndBegin.ValueData    AS EndBegin
           ----���� �������� wms
           , Object_Status_wms.Id                       AS StatusId_wms
           , Object_Status_wms.ObjectCode               AS StatusCode_wms
           , Object_Status_wms.ValueData                AS StatusName_wms
           --
           , MovementItem.Id                              AS MovementItemId
           --������� ������ (��/���)
           , MovementItem.isErased                        AS isErased_mi
           --�����
           , MovementItem.ObjectId                        AS GoodsId
           --��� ������
           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
           --����������
           , MovementItem.Amount                           AS Amount
           --����
           , COALESCE (MIFloat_Price.ValueData, 0)         AS Price
           --���� �� �������
           , COALESCE (MIFloat_PriceEDI.ValueData, 0)      AS PriceEDI
           --���� �� ����������
           , CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice
           --(-)% ������ (+)% �������
           , COALESCE (MIFloat_ChangePercent.ValueData, 0) AS ChangePercent_mi
           --���������� �������
           , MIFloat_AmountSecond.ValueData                AS AmountSecond
           --����� � ��� � �������
           , MIFloat_Summ.ValueData                        AS Summ
           --MovementId-�����
           , MIFloat_PromoMovement.ValueData               AS MovementId_Promo
           --�������� ����/����� ������
           , MIDate_StartBegin.ValueData                   AS StartBegin_mi
           --�������� ����/����� ����������
           , MIDate_EndBegin.ValueData                     AS EndBegin_mi

           -- ���������� ���
           , MovementItem.Amount 
             * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END :: TFloat AS Amount_Weight
           -- ���������� ��.
           , MovementItem.Amount 
             * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN 1 ELSE 0 END :: TFloat AS Amount_sh
                                    
       FROM Movement
            --��� �������
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
            --���� �������� �����������
            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            --���� ����������
            LEFT JOIN MovementDate AS MovementDate_OperDateMark
                                   ON MovementDate_OperDateMark.MovementId =  Movement.Id
                                  AND MovementDate_OperDateMark.DescId = zc_MovementDate_OperDateMark()
            --� ����/����� �������� ���������
            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            --� ����/����� �������� �� ��� ����.
            LEFT JOIN MovementDate AS MovementDate_InsertMobile
                                   ON MovementDate_InsertMobile.MovementId = Movement.Id
                                  AND MovementDate_InsertMobile.DescId = zc_MovementDate_InsertMobile()
            --�������� ����/����� ������
            LEFT JOIN MovementDate AS MovementDate_StartBegin
                                   ON MovementDate_StartBegin.MovementId = Movement.Id
                                  AND MovementDate_StartBegin.DescId = zc_MovementDate_StartBegin()
            --���� ������� (������.)
            LEFT JOIN MovementDate AS MovementDate_EndBegin
                                   ON MovementDate_EndBegin.MovementId = Movement.Id
                                  AND MovementDate_EndBegin.DescId = zc_MovementDate_EndBegin()
            --����/����� ��������
            LEFT JOIN MovementDate AS MovementDate_CarInfo
                                   ON MovementDate_CarInfo.MovementId = Movement.Id
                                  AND MovementDate_CarInfo.DescId = zc_MovementDate_CarInfo()
            --����� ����������
            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
            --����� ������ � �����������
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
            --�����������
            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()
            --���������� � ��������
            LEFT JOIN MovementString AS MovementString_CarComment
                                     ON MovementString_CarComment.MovementId = Movement.Id
                                    AND MovementString_CarComment.DescId = zc_MovementString_CarComment()
            --������������� (������ ������) / ����������
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_PrepareDayCount  ON ObjectFloat_PrepareDayCount.ObjectId = MovementLinkObject_From.ObjectId AND ObjectFloat_PrepareDayCount.DescId = zc_ObjectFloat_Partner_PrepareDayCount()
            LEFT JOIN ObjectFloat AS ObjectFloat_DocumentDayCount ON ObjectFloat_DocumentDayCount.ObjectId = MovementLinkObject_From.ObjectId AND ObjectFloat_DocumentDayCount.DescId = zc_ObjectFloat_Partner_DocumentDayCount()
            --������������� (������ ������) / �������������
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
            --���������� ����(����������)
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                         ON MovementLinkObject_Personal.MovementId = Movement.Id
                                        AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = MovementLinkObject_Personal.ObjectId
            --�������
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                         ON MovementLinkObject_Route.MovementId = Movement.Id
                                        AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()
            LEFT JOIN Object AS Object_Route ON Object_Route.Id = MovementLinkObject_Route.ObjectId
            --���������� ���������
            LEFT JOIN MovementLinkObject AS MovementLinkObject_RouteSorting
                                         ON MovementLinkObject_RouteSorting.MovementId = Movement.Id
                                        AND MovementLinkObject_RouteSorting.DescId = zc_MovementLinkObject_RouteSorting()
            LEFT JOIN Object AS Object_RouteSorting ON Object_RouteSorting.Id = MovementLinkObject_RouteSorting.ObjectId
            --���� ���� ������ 
            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId
            --�������
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId
            --�����-����
            LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceList
                                         ON MovementLinkObject_PriceList.MovementId = Movement.Id
                                        AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()
            LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = MovementLinkObject_PriceList.ObjectId
            --�������� ����
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Retail
                                         ON MovementLinkObject_Retail.MovementId = Movement.Id
                                        AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()
            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = MovementLinkObject_Retail.ObjectId
            --���� � ��� (��/���)
            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
            --��� �� ���������� �������� (��/���)
            LEFT JOIN MovementBoolean AS MovementBoolean_Print
                                      ON MovementBoolean_Print.MovementId = Movement.Id
                                     AND MovementBoolean_Print.DescId = zc_MovementBoolean_Print()
            --�������� ���������� � ��������� ���������
            LEFT JOIN MovementBoolean AS MovementBoolean_PrintComment
                                      ON MovementBoolean_PrintComment.MovementId = Movement.Id
                                     AND MovementBoolean_PrintComment.DescId = zc_MovementBoolean_PrintComment()
            -- ���� �� ������ � ������ � ���������
            LEFT JOIN MovementBoolean AS MovementBoolean_Promo
                                      ON MovementBoolean_Promo.MovementId = Movement.Id
                                     AND MovementBoolean_Promo.DescId = zc_MovementBoolean_Promo()
            --��� ����������� ������
            LEFT JOIN MovementBoolean AS MovementBoolean_Remains
                                      ON MovementBoolean_Remains.MovementId = Movement.Id
                                     AND MovementBoolean_Remains.DescId = zc_MovementBoolean_Remains()
            --% ���
            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
            --(-)% ������ (+)% �������
            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
            --����� ����������, ��
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountSh
                                    ON MovementFloat_TotalCountSh.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountSh.DescId = zc_MovementFloat_TotalCountSh()
            --����� ����������, ��
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                    ON MovementFloat_TotalCountKg.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()
            --����� ���������� �������
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountSecond
                                    ON MovementFloat_TotalCountSecond.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountSecond.DescId = zc_MovementFloat_TotalCountSecond()
            --����� ����� �� ��������� (��� ���)
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                    ON MovementFloat_TotalSummMVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
            --����� ����� �� ��������� (� ���)
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                    ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
            --����� ����� �� ��������� (� ������ ��� � ������)
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
            --�������� EDI
            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                           ON MovementLinkMovement_Order.MovementId = Movement.Id
                                          AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
            --����������
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                         ON MovementLinkObject_Partner.MovementId = Movement.Id
                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId
            --���������� �� ��������
            LEFT JOIN MovementLinkObject AS MovementLinkObject_CarInfo
                                         ON MovementLinkObject_CarInfo.MovementId = Movement.Id
                                        AND MovementLinkObject_CarInfo.DescId = zc_MovementLinkObject_CarInfo()
            LEFT JOIN Object AS Object_CarInfo ON Object_CarInfo.Id = MovementLinkObject_CarInfo.ObjectId
            --� ������������
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                         ON MovementLinkObject_Insert.MovementId = Movement.Id
                                        AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_Insert.ObjectId
            --���� �������� wms
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Status_wms
                                         ON MovementLinkObject_Status_wms.MovementId = Movement.Id
                                        AND MovementLinkObject_Status_wms.DescId = zc_MovementLinkObject_Status_wms()
            LEFT JOIN Object AS Object_Status_wms ON Object_Status_wms.Id = MovementLinkObject_Status_wms.ObjectId
            --� ���������� ���������� �������������
            LEFT JOIN MovementString AS MovementString_GUID
                                     ON MovementString_GUID.MovementId = Movement.Id
                                    AND MovementString_GUID.DescId = zc_MovementString_GUID()

            LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                 ON ObjectLink_User_Member.ObjectId = Object_User.Id
                                AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId

            --�������� �����
            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Promo
                                           ON MovementLinkMovement_Promo.MovementId = Movement.Id
                                          AND MovementLinkMovement_Promo.DescId = zc_MovementLinkMovement_Promo()
            LEFT JOIN Movement AS Movement_Promo ON Movement_Promo.Id = MovementLinkMovement_Promo.MovementChildId
            LEFT JOIN MovementDate AS MD_StartSale
                                   ON MD_StartSale.MovementId =  Movement_Promo.Id
                                  AND MD_StartSale.DescId = zc_MovementDate_StartSale()
            LEFT JOIN MovementDate AS MD_EndSale
                                   ON MD_EndSale.MovementId =  Movement_Promo.Id
                                  AND MD_EndSale.DescId = zc_MovementDate_EndSale()

            --������ ����������
            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                  AND MovementItem.DescId     = zc_MI_Master()
                                  --AND MovementItem.isErased   = tmpIsErased.isErased
            -- �����
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
            --��� �������
            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId
            --����
            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            --���� �� �������
            LEFT JOIN MovementItemFloat AS MIFloat_PriceEDI
                                        ON MIFloat_PriceEDI.MovementItemId = MovementItem.Id
                                       AND MIFloat_PriceEDI.DescId = zc_MIFloat_PriceEDI()
            --���� �� ����������
            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
            --���������� �������
            LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                        ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
            --����� � ��� � �������
            LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                        ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                       AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
            --MovementId-�����
            LEFT JOIN MovementItemFloat AS MIFloat_PromoMovement
                                        ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                       AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
            --(-)% ������ (+)% �������
            LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                        ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                       AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
            --�������� ����/����� ������
            LEFT JOIN MovementItemDate AS MIDate_StartBegin
                                       ON MIDate_StartBegin.MovementItemId = MovementItem.Id
                                      AND MIDate_StartBegin.DescId         = zc_MIDate_StartBegin()
            --�������� ����/����� ����������
            LEFT JOIN MovementItemDate AS MIDate_EndBegin
                                       ON MIDate_EndBegin.MovementItemId = MovementItem.Id
                                      AND MIDate_EndBegin.DescId         = zc_MIDate_EndBegin()

            -- ��.���. ������
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            -- ��� ������
            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()

        WHERE Movement.DescId = zc_Movement_OrderExternal()
          AND Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '1 DAY' AND CURRENT_DATE

        ;

ALTER TABLE _bi_Doc_OrderExternal_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.05.25         *
*/

-- ����
--SELECT _bi_Doc_OrderExternal_View.Id,_bi_Doc_OrderExternal_View.GoodsId  FROM _bi_Doc_OrderExternal_View 
-- WHERE OperDate BETWEEN CURRENT_DATE - INTERVAL '1 DAY' AND CURRENT_DATE
