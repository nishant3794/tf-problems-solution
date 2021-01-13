module "ec2_state_change" {
    source = "../modules/state_change"
    filename = "lambda.zip"
    function_name = "state_change_lambda"
}