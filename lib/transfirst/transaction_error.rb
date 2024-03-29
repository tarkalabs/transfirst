require 'transfirst/response_codes'
class Transfirst::TransactionError < StandardError
  attr_accessor :tran_code, :error_msg
  def initialize(resp)
    @tran_code = resp[:send_tran_response][:rsp_code]
    @error_msg = RESPONSE_CODES[@tran_code]
    @bare_resp = resp
  end
  def message
    "Transaction failed with code #{tran_code} -- #{error_msg}"
  end
end
