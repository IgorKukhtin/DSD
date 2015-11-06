DROP VIEW IF EXISTS Movement_PromoPartner_View;

CREATE OR REPLACE VIEW Movement_PromoPartner_View AS 
    SELECT       
        Movement_Promo.Id                                                 --�������������
      , Movement_Promo.ParentId                                           --������ �� �������� �������� <�����> (zc_Movement_Promo)
      , MovementLinkObject_Partner.ObjectId    AS PartnerId               --���������� ��� �����
      , Object_Partner.ObjectCode              AS PartnerCode             --���������� ��� �����
      , Object_Partner.ValueData               AS PartnerName             --���������� ��� �����
      , Object_Partner.DescId                  AS PartnerDescId           --��� ���������� ��� �����
      , ObjectDesc_Partner.ItemName            AS PartnerDescName         --��� ���������� ��� �����
      , CASE 
            WHEN Movement_Promo.StatusId = zc_Enum_Status_Erased()
                THEN TRUE
        ELSE FALSE
        END                                    AS isErased                --������
            
    FROM Movement AS Movement_Promo 

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                     ON MovementLinkObject_Partner.MovementId = Movement_Promo.Id
                                    AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
        LEFT JOIN Object AS Object_Partner 
                         ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId
        LEFT OUTER JOIN ObjectDesc AS ObjectDesc_Partner
                                   ON ObjectDesc_Partner.Id = Object_Partner.DescId
    WHERE Movement_Promo.DescId = zc_Movement_Promo()
      AND Movement_Promo.ParentId is not null;

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
