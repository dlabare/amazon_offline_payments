require 'openssl'
require 'base64'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:

    class AmazonOfflinePaymentsGateway < Gateway
      
      class_attribute :test_url, :live_url

      self.test_url = 'https://mws.amazonservices.com/OffAmazonPayments_Sandbox/2013-01-01/'
      self.live_url = 'https://mws.amazonservices.com/OffAmazonPayments/2013-01-01/'
      
      self.homepage_url = ''
      self.display_name = 'Amazon Offline Payments'
      self.supported_countries = ['US']
      self.default_currency = 'USD'
      
      
      # Creates a new AmazonOfflinePaymentsGateway
      #
      def initialize(options = {})
        options[:seller_id]     ||= ENV['MWS_SELLER_ID']
        options[:access_key_id] ||= ENV['MWS_ACCESS_KEY_ID']
        options[:secret_key]    ||= ENV['MWS_SECRET_KEY']
        options[:version]         = '2013-01-01'
        
        requires!(options, :seller_id, :access_key_id, :secret_key)
        @options = options
        super
      end
      
      # GetServiceStatus
      #
      # Returns the operational status of the Off-Amazon Payments API section.
      # @see http://docs.developer.amazonservices.com/en_US/off_amazon_payments/OffAmazonPayments_GetServiceStatus.html
      #
      def get_service_status
        commit('GetServiceStatus')
      end

      #-----------------------------------------------------------------------#
      # Billing Agreement Operations                                          #
      #-----------------------------------------------------------------------#
      
      # CreateOrderReferenceForId
      #
      # Creates an order reference for the given object.
      # @see http://docs.developer.amazonservices.com/en_US/off_amazon_payments/OffAmazonPayments_CreateOrderReferenceForId.html
      #
      def create_order_reference_for_id(options = {})
        requires!(options, :id, :id_type)
        commit('CreateOrderReferenceForId', options)
      end

      # GetBillingAgreementDetails
      #
      # Returns details about the Billing Agreement object and its current state.
      # @see http://docs.developer.amazonservices.com/en_US/off_amazon_payments/OffAmazonPayments_GetBillingAgreementDetails.html
      #
      def get_billing_agreement_details(options = {})
        requires!(options, :amazon_billing_agreement_id)
        commit('GetBillingAgreementDetails', options)
      end

      # SetBillingAgreementDetails
      #
      # Sets billing agreement details such as a description of the agreement and other information about the seller.
      # @see http://docs.developer.amazonservices.com/en_US/off_amazon_payments/OffAmazonPayments_SetBillingAgreementDetails.html
      #
      def set_billing_agreement_details(options = {})
        requires!(options, :amazon_billing_agreement_id, :billing_agreement_attributes)
        commit('SetBillingAgreementDetails', options)
      end

      # ConfirmBillingAgreement
      #
      # Confirms that the billing agreement is free of constraints and all required information has been set on the billing agreement.
      # @see http://docs.developer.amazonservices.com/en_US/off_amazon_payments/OffAmazonPayments_ConfirmBillingAgreement.html
      #
      def set_billing_agreement_details(options = {})
        requires!(options, :amazon_billing_agreement_id)
        commit('ConfirmBillingAgreement', options)
      end

      # ValidateBillingAgreement
      #
      # Validates the status of the BillingAgreement object and the payment method associated with it.
      # @see http://docs.developer.amazonservices.com/en_US/off_amazon_payments/OffAmazonPayments_ValidateBillingAgreement.html
      #
      def validate_billing_agreement(options = {})
        requires!(options, :amazon_billing_agreement_id)
        commit('ValidateBillingAgreement', options)
      end

      # AuthorizeOnBillingAgreement
      #
      # Reserves a specified amount against the payment method(s) stored in the billing agreement.
      # @see http://docs.developer.amazonservices.com/en_US/off_amazon_payments/OffAmazonPayments_AuthorizeOnBillingAgreement.html
      #
      def authorize_on_billing_agreement(options = {})
        requires!(options, :amazon_billing_agreement_id, :authorization_reference_id, :authorization_amount)
        commit('AuthorizeOnBillingAgreement', options)
      end

      # CloseBillingAgreement
      #
      # Confirms that you want to terminate the billing agreement with the buyer and that you do not expect to create any new order references or authorizations on this billing agreement.
      # @see http://docs.developer.amazonservices.com/en_US/off_amazon_payments/OffAmazonPayments_CloseBillingAgreement.html
      #
      def close_billing_agreement(options = {})
        requires!(options, :amazon_billing_agreement_id)
        commit('CloseBillingAgreement', options)
      end

      #-----------------------------------------------------------------------#
      # Order Reference Operations                                            #
      #-----------------------------------------------------------------------#

      # SetOrderReferenceDetails
      #
      # Sets order reference details such as the order total and a description for the order.
      # @see http://docs.developer.amazonservices.com/en_US/off_amazon_payments/OffAmazonPayments_SetOrderReferenceDetails.html
      #
      def set_order_reference_details(options = {})
        requires!(options, :amazon_order_reference_id, :order_reference_attributes)
        requires!(options[:order_reference_attributes], :order_total)
        requires!(options[:order_reference_attributes][:order_total], :amount, :currency_code)
        commit('SetOrderReferenceDetails', options)
      end

      # GetOrderReferenceDetails
      #
      # Returns details about the Order Reference object and its current state.
      # @see http://docs.developer.amazonservices.com/en_US/off_amazon_payments/OffAmazonPayments_GetOrderReferenceDetails.html
      #
      def get_order_reference_details(options = {})
        requires!(options, :amazon_order_reference_id)
        commit('GetOrderReferenceDetails', options)
      end
      
      # ConfirmOrderReference
      #
      # Confirms that the order reference is free of constraints and all required information has been set on the order reference.
      # @see http://docs.developer.amazonservices.com/en_US/off_amazon_payments/OffAmazonPayments_ConfirmOrderReference.html
      #
      def confirm_order_reference(options = {})
        requires!(options, :amazon_order_reference_id)
        commit('ConfirmOrderReference', options)
      end
      
      # CancelOrder
      #
      # Cancels a previously confirmed order reference.
      # @see: http://docs.developer.amazonservices.com/en_US/off_amazon_payments/OffAmazonPayments_CancelOrderReference.html
      #
      def cancel_order_reference(options = {})
        requires!(options, :amazon_order_reference_id)
        commit('CancelOrderReference', options)
      end
      
      # CloseOrderReference
      #
      # Confirms that an order reference has been fulfilled (fully or partially) and that you do not expect to create any new authorizations on this order reference.
      # @see: http://docs.developer.amazonservices.com/en_US/off_amazon_payments/OffAmazonPayments_CloseOrderReference.html
      #
      def close_order_reference(options = {})
        requires!(options, :amazon_order_reference_id)
        commit('CloseOrderReference', options)
      end
      
      #-----------------------------------------------------------------------#
      # Authorization Operations                                              #
      #-----------------------------------------------------------------------#
      
      # Authorize
      # 
      # Reserves a specified amount against the payment method(s) stored in the order reference.
      # @see: http://docs.developer.amazonservices.com/en_US/off_amazon_payments/OffAmazonPayments_Authorize.html
      #
      def authorize(options = {})
        requires!(options, :amazon_order_reference_id, :authorization_reference_id, :authorization_amount)
        requires!(options[:authorization_amount], :amount, :currency_code)
        commit('Authorize', options)
      end
      
      # GetAuthorizationDetails
      #
      # Returns the status of a particular authorization and the total amount captured on the authorization.
      # @see: http://docs.developer.amazonservices.com/en_US/off_amazon_payments/OffAmazonPayments_GetAuthorizationDetails.html
      #
      def get_authorization_details(options = {})
        requires!(options, :amazon_authorization_id)
        commit('GetAuthorizationDetails', options)
      end
      
      # CloseAuthorization
      #
      # Closes an authorization.
      # @see: http://docs.developer.amazonservices.com/en_US/off_amazon_payments/OffAmazonPayments_CloseAuthorization.html
      #
      def close_authorization(options = {})
        requires!(options, :amazon_authorization_id)
        commit('CloseAuthorization', options)
      end
      
      # Capture
      #
      # Captures funds from an authorized payment instrument.
      # @see: http://docs.developer.amazonservices.com/en_US/off_amazon_payments/OffAmazonPayments_Capture.html
      #
      def capture(options = {})
        requires!(options, :amazon_authorization_id, :capture_reference_id, :capture_amount)
        requires!(options[:capture_amount], :amount, :currency_code)
        commit('Capture', options)
      end
      
      # GetCaptureDetails
      #
      # Returns the status of a particular capture and the total amount refunded on the capture.
      # @see: http://docs.developer.amazonservices.com/en_US/off_amazon_payments/OffAmazonPayments_GetCaptureDetails.html
      #
      def get_capture_details(options = {})
        requires!(options, :amazon_capture_id)
        commit('GetCaptureDetails', options)
      end

      #-----------------------------------------------------------------------#
      # Refund Operations                                                     #
      #-----------------------------------------------------------------------#

      # Refund
      #
      # Refunds a previously captured amount.
      # @see: http://docs.developer.amazonservices.com/en_US/off_amazon_payments/OffAmazonPayments_Refund.html
      #
      def refund(options = {})
        requires!(options, :amazon_capture_id, :refund_reference_id, :refund_amount)
        commit('Refund', options)
      end

      # GetRefundDetails
      #
      # Returns the status of a particular refund.
      # @see: http://docs.developer.amazonservices.com/en_US/off_amazon_payments/OffAmazonPayments_GetRefundDetails.html
      #
      def get_refund_details(options = {})
        requires!(options, :amazon_refund_id)
        commit('GetRefundDetails', options)
      end
      
      private
    
        #
        # commit logic
        #
        def stringify_params(params)
          params.sort_by{|k,v| k}.collect{|p| "#{p.first}=#{CGI.escape(p.last.to_s)}" }.join("&")
        end
        
        def default_params(action)
          {
            'AWSAccessKeyId' => options[:access_key_id],
            'SellerId'       => options[:seller_id],
            'Action'         => action,
            'Timestamp'      => Time.now.utc.iso8601,
            'Version'        => options[:version],
            'SignatureMethod'   => 'HmacSHA256',
            'SignatureVersion'  => '2'
          }
        end

        #
        # @see: http://docs.developer.amazonservices.com/en_US/dev_guide/DG_ClientLibraries.html
        #
        def signature(params)
          path        = URI.parse(url = test? ? self.test_url : self.live_url).path
          data        = "POST\nmws.amazonservices.com\n#{path}\n#{stringify_params(params)}"
          sig         = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), options[:secret_key], data)).strip()
          verbose('Signature', "Query String:\n#{data}\n\nSignature: #{sig}")
          return sig
        end

        def commit(action, params = {})
          raw_response = response = nil
          success = false

          uri = URI.parse(url = test? ? self.test_url : self.live_url)
      
          response = begin
            http              = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl      = true
            http.verify_mode  = OpenSSL::SSL::VERIFY_PEER
            
            post_params = Hash.dot_notation(params.merge(default_params(action)))
            post_params['Signature'] = signature(post_params)
            
            request = Net::HTTP::Post.new(uri.request_uri)
            request.set_form_data(post_params)
            
            verbose('Request', "#{uri.to_s}?#{request.body}")
            raw_response = http.request(request)
            verbose('Response', raw_response.body)
            
            hash = Hash.from_xml(raw_response.body)
            
            if error = hash['ErrorResponse']
              Response.new(false, "#{error['Error']['Code']} - #{error['Error']['Message']}", error, :test => test?)
            else
              hash = hash["#{action}Response"]
              hash = hash && hash.has_key?("#{action}Result") ? hash["#{action}Result"] : hash
              hash = hash && hash.has_key?("#{action.gsub('Get', '')}") ? hash["#{action.gsub('Get', '')}"] : hash
              Response.new(true, "#{action}: success", hash || {}, :test => test?)
            end
          rescue NoMethodError => e
            Response.new(false, "#{action}: fail", {'Error' => "NoMethodError: #{e.message}"}, :test => test?)
          rescue ResponseError => e
            Response.new(false, "#{action}: fail", {'Error' => "ResponseError: #{e.message}"}, :test => test?)
          rescue Exception => e
            Response.new(false, "#{action}: fail", {'Error' => "Exception: #{e.message}"}, :test => test?)
          end
        
          return response
        end
        
        def verbose(section, msg)
          return unless options[:verbose]
          puts "\n[AmazonOfflinePayments: #{section}]"
          puts msg
          puts "\n"
        end
      
    end
    
  end
  
end
