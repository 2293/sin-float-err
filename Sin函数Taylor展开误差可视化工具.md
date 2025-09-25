Sin函数Taylor展开误差可视化工具

我将创建一个HTML页面，允许用户输入range函数参数，计算Sin函数的Taylor展开近似值，并可视化误差。

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sin函数Taylor展开误差分析</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background: linear-gradient(135deg, #1a2a6c, #b21f1f, #fdbb2d);
            color: white;
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: rgba(0, 0, 0, 0.7);
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
        }
        
        header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        h1 {
            font-size: 2.5rem;
            margin-bottom: 10px;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
        }
        
        .description {
            font-size: 1.1rem;
            max-width: 800px;
            margin: 0 auto 20px;
            line-height: 1.6;
        }
        
        .input-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .input-group {
            background: rgba(255, 255, 255, 0.1);
            padding: 20px;
            border-radius: 10px;
        }
        
        h2 {
            font-size: 1.5rem;
            margin-bottom: 15px;
            color: #fdbb2d;
        }
        
        .form-group {
            margin-bottom: 15px;
        }
        
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
        }
        
        input {
            width: 100%;
            padding: 10px;
            border: none;
            border-radius: 5px;
            background: rgba(255, 255, 255, 0.9);
            font-size: 1rem;
        }
        
        button {
            background: #fdbb2d;
            color: #1a2a6c;
            border: none;
            padding: 12px 25px;
            border-radius: 5px;
            font-size: 1.1rem;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s;
            display: block;
            margin: 20px auto 0;
            width: 200px;
        }
        
        button:hover {
            background: #ffcc44;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
        }
        
        .results {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .chart-container {
            background: rgba(255, 255, 255, 0.1);
            padding: 20px;
            border-radius: 10px;
            height: 400px;
        }
        
        .data-display {
            background: rgba(255, 255, 255, 0.1);
            padding: 20px;
            border-radius: 10px;
            overflow: auto;
            max-height: 400px;
        }
        
        .data-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .data-table th, .data-table td {
            padding: 8px 12px;
            text-align: left;
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .data-table th {
            background: rgba(255, 255, 255, 0.1);
            color: #fdbb2d;
        }
        
        .summary {
            background: rgba(255, 255, 255, 0.1);
            padding: 20px;
            border-radius: 10px;
            margin-top: 20px;
        }
        
        .summary-item {
            margin-bottom: 10px;
            display: flex;
            justify-content: space-between;
        }
        
        .summary-value {
            font-weight: bold;
            color: #fdbb2d;
        }
        
        @media (max-width: 768px) {
            .results {
                grid-template-columns: 1fr;
            }
            
            .input-section {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <h1>Sin函数Taylor展开误差分析</h1>
            <p class="description">
                本工具允许您生成一个Float32Array，将其值映射到[-π/2, π/2]区间，然后使用Taylor展开近似计算sin函数值，
                并与Math.sin()的精确值进行比较，最终可视化误差分布。
            </p>
        </header>
        
        <section class="input-section">
            <div class="input-group">
                <h2>Range函数参数</h2>
                <div class="form-group">
                    <label for="start">起始值 (start):</label>
                    <input type="number" id="start" value="0" step="any">
                </div>
                <div class="form-group">
                    <label for="stop">结束值 (stop):</label>
                    <input type="number" id="stop" value="10" step="any">
                </div>
                <div class="form-group">
                    <label for="step">步长 (step):</label>
                    <input type="number" id="step" value="0.5" step="any">
                </div>
            </div>
            
            <div class="input-group">
                <h2>Taylor展开参数</h2>
                <div class="form-group">
                    <label for="n">展开项数 (n):</label>
                    <input type="number" id="n" value="5" min="1" max="20">
                </div>
                <div class="form-group">
                    <label for="precision">精度控制 (小数位数):</label>
                    <input type="number" id="precision" value="6" min="0" max="10">
                </div>
            </div>
        </section>
        
        <button id="calculateBtn">计算并可视化</button>
        
        <section class="results">
            <div class="chart-container">
                <canvas id="errorChart"></canvas>
            </div>
            
            <div class="data-display">
                <h2>数据详情</h2>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>索引</th>
                            <th>原值</th>
                            <th>降周期值</th>
                            <th>Taylor近似</th>
                            <th>Math.sin()</th>
                            <th>绝对误差</th>
                        </tr>
                    </thead>
                    <tbody id="dataTableBody">
                        <!-- 数据将通过JavaScript填充 -->
                    </tbody>
                </table>
            </div>
        </section>
        
        <section class="summary">
            <h2>误差统计</h2>
            <div class="summary-item">
                <span>最大绝对误差:</span>
                <span id="maxError" class="summary-value">-</span>
            </div>
            <div class="summary-item">
                <span>平均绝对误差:</span>
                <span id="avgError" class="summary-value">-</span>
            </div>
            <div class="summary-item">
                <span>均方根误差 (RMSE):</span>
                <span id="rmse" class="summary-value">-</span>
            </div>
            <div class="summary-item">
                <span>数据点数:</span>
                <span id="dataPoints" class="summary-value">-</span>
            </div>
        </section>
    </div>

    <script>
        // Range函数实现
        function range(start, stop, step = 1) {
            if (stop === undefined) {
                stop = start;
                start = 0;
            }
            
            if (step === 0) {
                throw new Error("步长不能为0");
            }
            
            const length = Math.max(0, Math.ceil((stop - start) / step));
            const result = new Float32Array(length);
            
            for (let i = 0; i < length; i++) {
                result[i] = start + i * step;
            }
            
            return result;
        }
        
        // 将值映射到[-π/2, π/2]区间
        function reduceToSinDomain(x) {
            // 使用模运算将x映射到[0, 2π)区间
            x = x % (2 * Math.PI);
            
            // 如果x为负，转换为正
            if (x < 0) x += 2 * Math.PI;
            
            // 将x映射到[-π/2, π/2]区间
            if (x <= Math.PI/2) {
                return x;
            } else if (x <= 3*Math.PI/2) {
                return Math.PI - x;
            } else {
                return x - 2*Math.PI;
            }
        }
        
        // 计算阶乘
        function factorial(n) {
            if (n === 0 || n === 1) return 1;
            let result = 1;
            for (let i = 2; i <= n; i++) {
                result *= i;
            }
            return result;
        }
        
        // Sin函数的Taylor展开
        function taylorSin(x, n) {
            let result = 0;
            for (let i = 0; i < n; i++) {
                const exponent = 2*i + 1;
                const term = Math.pow(-1, i) * Math.pow(x, exponent) / factorial(exponent);
                result += term;
            }
            return result;
        }
        
        // 计算误差统计
        function calculateErrorStats(errors) {
            const maxError = Math.max(...errors);
            const avgError = errors.reduce((sum, err) => sum + err, 0) / errors.length;
            const rmse = Math.sqrt(errors.reduce((sum, err) => sum + err*err, 0) / errors.length);
            
            return {
                maxError: maxError,
                avgError: avgError,
                rmse: rmse
            };
        }
        
        // 更新数据表格
        function updateDataTable(originalValues, reducedValues, taylorValues, sinValues, errors) {
            const tableBody = document.getElementById('dataTableBody');
            tableBody.innerHTML = '';
            
            const precision = parseInt(document.getElementById('precision').value) || 6;
            
            for (let i = 0; i < originalValues.length; i++) {
                const row = document.createElement('tr');
                
                row.innerHTML = `
                    <td>${i}</td>
                    <td>${originalValues[i].toFixed(precision)}</td>
                    <td>${reducedValues[i].toFixed(precision)}</td>
                    <td>${taylorValues[i].toFixed(precision)}</td>
                    <td>${sinValues[i].toFixed(precision)}</td>
                    <td>${errors[i].toFixed(precision)}</td>
                `;
                
                tableBody.appendChild(row);
            }
        }
        
        // 更新统计信息
        function updateStats(stats, dataLength) {
            const precision = parseInt(document.getElementById('precision').value) || 6;
            
            document.getElementById('maxError').textContent = stats.maxError.toFixed(precision);
            document.getElementById('avgError').textContent = stats.avgError.toFixed(precision);
            document.getElementById('rmse').textContent = stats.rmse.toFixed(precision);
            document.getElementById('dataPoints').textContent = dataLength;
        }
        
        // 绘制误差图表
        let errorChart = null;
        function drawErrorChart(labels, errors) {
            const ctx = document.getElementById('errorChart').getContext('2d');
            
            if (errorChart) {
                errorChart.destroy();
            }
            
            errorChart = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [{
                        label: '绝对误差',
                        data: errors,
                        borderColor: '#fdbb2d',
                        backgroundColor: 'rgba(253, 187, 45, 0.1)',
                        borderWidth: 2,
                        fill: true,
                        tension: 0.4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        title: {
                            display: true,
                            text: 'Taylor展开近似误差',
                            color: 'white',
                            font: {
                                size: 16
                            }
                        },
                        legend: {
                            labels: {
                                color: 'white'
                            }
                        }
                    },
                    scales: {
                        x: {
                            title: {
                                display: true,
                                text: '数据点索引',
                                color: 'white'
                            },
                            ticks: {
                                color: 'white'
                            },
                            grid: {
                                color: 'rgba(255, 255, 255, 0.1)'
                            }
                        },
                        y: {
                            title: {
                                display: true,
                                text: '绝对误差',
                                color: 'white'
                            },
                            ticks: {
                                color: 'white'
                            },
                            grid: {
                                color: 'rgba(255, 255, 255, 0.1)'
                            }
                        }
                    }
                }
            });
        }
        
        // 主计算函数
        function calculateAndVisualize() {
            try {
                // 获取用户输入
                const start = parseFloat(document.getElementById('start').value);
                const stop = parseFloat(document.getElementById('stop').value);
                const step = parseFloat(document.getElementById('step').value);
                const n = parseInt(document.getElementById('n').value);
                
                // 验证输入
                if (isNaN(start) || isNaN(stop) || isNaN(step) || isNaN(n)) {
                    alert('请输入有效的数值参数');
                    return;
                }
                
                if (step === 0) {
                    alert('步长不能为0');
                    return;
                }
                
                if (n < 1) {
                    alert('Taylor展开项数必须至少为1');
                    return;
                }
                
                // 生成Float32Array
                const a = range(start, stop, step);
                
                // 降周期处理
                const a1 = new Float32Array(a.length);
                for (let i = 0; i < a.length; i++) {
                    a1[i] = reduceToSinDomain(a[i]);
                }
                
                // 计算Taylor展开近似值和Math.sin精确值
                const taylorResults = new Float32Array(a.length);
                const sinResults = new Float32Array(a.length);
                const errors = new Float32Array(a.length);
                
                for (let i = 0; i < a.length; i++) {
                    taylorResults[i] = taylorSin(a1[i], n);
                    sinResults[i] = Math.sin(a[i]);
                    errors[i] = Math.abs(taylorResults[i] - sinResults[i]);
                }
                
                // 计算误差统计
                const stats = calculateErrorStats(errors);
                
                // 生成标签（索引）
                const labels = Array.from({length: a.length}, (_, i) => i.toString());
                
                // 更新界面
                updateDataTable(a, a1, taylorResults, sinResults, errors);
                updateStats(stats, a.length);
                drawErrorChart(labels, errors);
                
            } catch (error) {
                alert('计算过程中出现错误: ' + error.message);
                console.error(error);
            }
        }
        
        // 绑定计算按钮事件
        document.getElementById('calculateBtn').addEventListener('click', calculateAndVisualize);
        
        // 页面加载时自动计算一次
        window.addEventListener('load', calculateAndVisualize);
    </script>
</body>
</html>
```

功能说明

这个HTML页面实现了以下功能：

1. Range函数参数输入：用户可以输入start、stop和step参数来生成Float32Array
2. 降周期处理：将原始值映射到[-π/2, π/2]区间
3. Taylor展开计算：使用用户指定的项数计算sin函数的Taylor展开近似值
4. 误差分析：比较Taylor展开近似值与Math.sin()精确值的误差
5. 数据可视化：使用Chart.js绘制误差分布图表
6. 详细数据展示：以表格形式展示每个数据点的计算结果
7. 误差统计：计算并显示最大误差、平均误差和均方根误差

使用方法

1. 在左侧输入区域设置Range函数的参数（起始值、结束值、步长）
2. 在右侧设置Taylor展开的项数和精度控制
3. 点击"计算并可视化"按钮生成结果
4. 查看图表、数据表格和误差统计信息

页面具有响应式设计，可以在不同尺寸的设备上正常显示。