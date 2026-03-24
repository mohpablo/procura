<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Invoice #{{ $order->id }}</title>
    <style>
        body { font-family: sans-serif; font-size: 14px; color: #333; }
        .header { text-align: center; margin-bottom: 30px; border-bottom: 2px solid #ddd; padding-bottom: 20px; }
        .logo { font-size: 24px; font-weight: bold; color: #2563eb; }
        .invoice-details { margin-bottom: 30px; }
        .invoice-details td { padding: 5px; }
        .addresses { width: 100%; margin-bottom: 40px; }
        .addresses td { width: 50%; vertical-align: top; }
        .section-title { font-weight: bold; margin-bottom: 10px; font-size: 16px; border-bottom: 1px solid #ddd; padding-bottom: 5px; }
        table.items { width: 100%; border-collapse: collapse; margin-bottom: 30px; }
        table.items th { background-color: #f8fafc; padding: 10px; text-align: left; border-bottom: 2px solid #ddd; }
        table.items td { padding: 10px; border-bottom: 1px solid #ddd; }
        .totals { width: 50%; float: right; }
        .totals td { padding: 5px; text-align: right; }
        .totals .final { font-size: 18px; font-weight: bold; border-top: 2px solid #ddd; padding-top: 10px; }
        .footer { clear: both; margin-top: 50px; text-align: center; color: #777; font-size: 12px; }
    </style>
</head>
<body>
    <div class="header">
        <div class="logo">B2B Marketplace</div>
        <h2>TAX INVOICE</h2>
    </div>

    <table class="addresses">
        <tr>
            <td>
                <div class="section-title">From (Supplier)</div>
                <strong>{{ $order->supplier->name }}</strong><br>
                {{ $order->supplier->address }}<br>
                Phone: {{ $order->supplier->phone }}<br>
                Email: {{ $order->supplier->email }}
            </td>
            <td>
                <div class="section-title">To (Buyer)</div>
                <strong>{{ $order->buyer->company ? $order->buyer->company->name : $order->buyer->name }}</strong><br>
                {{ $order->buyer->address }}<br>
                Phone: {{ $order->buyer->phone }}<br>
                Email: {{ $order->buyer->email }}
            </td>
        </tr>
    </table>

    <table class="invoice-details">
        <tr>
            <td><strong>Invoice Number:</strong> INV-{{ str_pad($order->id, 6, '0', STR_PAD_LEFT) }}</td>
            <td><strong>Date Issued:</strong> {{ $order->created_at->format('M d, Y') }}</td>
        </tr>
        <tr>
            <td><strong>Order ID:</strong> #{{ $order->id }}</td>
            <td><strong>Payment Status:</strong> {{ ucfirst($order->payment_status) }}</td>
        </tr>
    </table>

    <table class="items">
        <thead>
            <tr>
                <th>Description</th>
                <th>Quantity</th>
                <th>Unit Price</th>
                <th>Total</th>
            </tr>
        </thead>
        <tbody>
            @foreach($order->orderItems as $item)
            <tr>
                <td>{{ $item->product->name }}</td>
                <td>{{ $item->quantity }} {{ $item->product->unit }}</td>
                <td>${{ number_format($item->unit_price, 2) }}</td>
                <td>${{ number_format($item->total_price, 2) }}</td>
            </tr>
            @endforeach
        </tbody>
    </table>

    <table class="totals">
        <tr>
            <td>Subtotal:</td>
            <td>${{ number_format($order->total_amount, 2) }}</td>
        </tr>
        <tr>
            <td>Tax (0%):</td>
            <td>$0.00</td>
        </tr>
        <tr>
            <td class="final">Total Amount:</td>
            <td class="final">${{ number_format($order->total_amount, 2) }}</td>
        </tr>
    </table>

    <div class="footer">
        Thank you for your business. If you have any questions, please contact our support.
    </div>
</body>
</html>
