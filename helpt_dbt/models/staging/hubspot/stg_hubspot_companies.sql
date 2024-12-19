SELECT 
    id,
    properties_name AS name,
    properties_closedate AS closed_date,
    properties_plan_1_launch_date,
    properties_plan_1_quantity,
    properties_plan_1_sign_up_date,
    properties_plan_2_launch_date,
    properties_plan_2_quantity,
    properties_plan_2_sign_up_date,
    properties_plan_1_type,
    properties_plan_2_type,
    properties_plan_2_tmetric,
    properties_plan_2_ringcentral_1__cloned_,
    properties_plan_1_ringcentral_1,
    properties_plan_1_ringcentral_2,
    properties_plan_2_ringcentral_2,
    properties_plan_1_tmetric
FROM {{ source('hubspot', 'companies') }}
