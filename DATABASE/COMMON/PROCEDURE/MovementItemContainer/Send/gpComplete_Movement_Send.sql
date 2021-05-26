-- Function: gpComplete_Movement_Send()

DROP FUNCTION IF EXISTS gpComplete_Movement_Send (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Send(
    IN inMovementId        Integer              , -- ���� ���������
    IN inIsLastComplete    Boolean DEFAULT False, -- ��� ��������� ���������� ����� ������� �/� (��� ������� �������� !!!�� ��������������!!!)
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     IF inSession = zc_Enum_Process_Auto_PrimeCost() :: TVarChar
     THEN vbUserId:= lpGetUserBySession (inSession);
     ELSE vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Send());
     END IF;


     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Send_CreateTemp();


     -- !!!��������!!!
     PERFORM lpComplete_Movement_Send (inMovementId:= inMovementId
                                     , inUserId    := vbUserId
                                      );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.08.14                                        * add MovementDescId
 13.08.14                                        * add lpInsertUpdate_MIReport_byTable
 12.08.14                                        * add inBranchId :=
 05.08.14                                        * add UnitId_Item and ...
 25.05.14                                        * add lpComplete_Movement
 21.12.13                                        * Personal -> Member
 06.10.13                                        * add StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
 03.10.13                                        * add inCarId := NULL
 17.09.13                                        * add lpInsertUpdate_ContainerCount_Goods and lpInsertUpdate_ContainerSumm_Goods
 15.09.13                                        * add zc_Enum_Account_20901
 14.09.13                                        * add zc_ObjectLink_Goods_Business
 02.09.13                                        * add lpInsertUpdate_MovementItemContainer_byTable
 26.08.13                                        * add zc_InfoMoneyDestination_WorkProgress
 11.08.13                                        * add inIsLastComplete
 10.08.13                                        * � ��������� ��� ��������������� � ��������� �����: Master - ������, Child - ������ (�.�. ����������� �� ����� 1:1)
 09.08.13                                        * add zc_isHistoryCost and zc_isHistoryCost_byInfoMoneyDetail
 07.08.13                                        * add inParentId and inIsActive
 24.07.13                                        * !�����������! ��������� ����
 20.07.13                                        * add MovementItemId
 20.07.13                                        * all ������ ������, ���� ���� ...
 19.07.13                                        *
*/

/*
����� ����������� �� - ����� ������ - �� �������� ������ �� "�� �� ����" - �������� � ����� ������ zc_ContainerLinkObject_AssetTo + zc_ContainerLinkObject_PartionGoods : zc_ObjectLink_PartionGoods_Unit + zc_ObjectLink_PartionGoods_Storage = ����� �������� + Object.ValueData = ��� ����� + zc_ObjectDate_PartionGoods_Value = ���� ����������� + zc_ObjectFloat_PartionGoods_Price = "���� ��������" � ��������� � gpInsertUpdate_MovementItem_SendMember ������ 1) inGoodsId + inGoodsKindId + inAssetId + inPartionGoodsDate + ioPartionGoods + inUnitId + inStorageId - ��������� ������� + �� ������� ���� + � ����� �������� ��� ������ ������ StorageId , �.�. �� �������� ��� - SELECT Container union all  MovementItem ��� ����� ������ + ����� +inAssetId  ��� ���� � ������� �� ������ ������������� + ���� ��� ����������� �� ������ �� �� - ����� � zc_ContainerLinkObject_PartionGoods ��� ������ = ���� , � ����� ��� ��-�� �� �������� ��� ��, � ���� �� �������� �����  � �� "�������� ���" ���� ����� GoodsId + GoodsKindId
*/
-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 579, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpComplete_Movement_Send (inMovementId:= 5854348, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 579, inSession:= zfCalc_UserAdmin())
