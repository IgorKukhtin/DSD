DROP VIEW IF EXISTS Movement_Promo_View;

CREATE OR REPLACE VIEW Movement_Promo_View AS 
    SELECT       
        Movement_Promo.Id                                                 --�������������
      , Movement_Promo.ParentId                                           --������ �� �������� �������� <�����> (zc_Movement_Promo)
      , zc_MovementLinkObject_Partner.ObjectId AS PartnerId               --���������� ��� �����
      , Object_Partner.ValueData               AS PartnerName             --���������� ��� �����
      , Object_Partner.DescId                  AS PartnerDescId           --��� ���������� ��� �����
      , ObjectDesc_Partner.DescName            AS PartnerDescName         --��� ���������� ��� �����
    FROM Movement AS Movement_Promo 
        LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

        LEFT JOIN MovementLinkObject AS zc_MovementLinkObject_Partner
                                     ON zc_MovementLinkObject_Partner.MovementId = Movement.Id
                                    AND zc_MovementLinkObject_Partner.DescId = zc_zc_MovementLinkObject_Partner()
        LEFT JOIN Object AS Object_Partner 
                         ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId
        LEFT OUTER JOIN ObjectDesc AS ObjectDesc_Partner
                                   ON ObjectDesc_Partner.Id = Object_Partner.DescId
    WHERE Movement.DescId = zc_Movement_Promo()
      AND Movement.ParentId is not null;

ALTER TABLE Movement_Promo_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 31.10.15                                                         * 
*/

-- ����
-- SELECT * FROM Movement_Promo_View  where id = 805
