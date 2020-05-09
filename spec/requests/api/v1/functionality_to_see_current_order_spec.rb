RSpec.describe Api::V1::OrdersController, type: :request do 
  let!(:product_1) {create(:product, title: 'Pizza')}
  let!(:product_2) {create(:product, title: 'Hamburger')}

  before do
    post '/api/v1/orders/', 
    params: {
      product_id: product_1.id
    }
    @order_id = response_json["order_id"]
  end
  
  describe 'POST /api/v1/order' do
    it "successfully" do       
      expect(response_json['message']).to eq 'The product has been added to your order'
    end
    
    it 'should return a 200 response' do
      expect(response).to have_http_status 200
    end

    it "should return order id in response" do
      order = Order.find(@order_id)
      expect(response_json["order_id"]).to eq order.id
    end
  end

  describe 'PUT /api/v1/orders/:id' do
    before do
      put "/api/v1/orders/#{@order_id}", params: { product_id: product_2.id }
      @order = Order.find(@order_id)
    end

    it "adds another product to the order" do
      expect(@order.order_items.count).to eq 2
    end

    it "responds with order id" do
      expect(response_json["order_id"]).to eq @order.id
    end
  end
end