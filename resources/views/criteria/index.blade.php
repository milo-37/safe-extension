<x-app-layout>
    <x-slot name="header">
        <h2 class="font-semibold text-2xl text-red-400 tracking-wide leading-tight">
            🚫 {{ __('Danh sách Tiêu chí') }}
        </h2>
    </x-slot>

    <div class="min-h-screen bg-gray-900 text-white py-12">
        <div class="max-w-5xl mx-auto sm:px-6 lg:px-8">
            <div class="relative bg-gray-800 shadow-xl sm:rounded-lg p-6 border border-green-500">

                <div class="absolute inset-0 bg-green-500 opacity-10 blur-lg rounded-lg pointer-events-none"></div>

                <h2 class="text-2xl font-bold mb-6 text-red-400">🚫 Danh sách Tiêu chí</h2>

                @if ($criteria->count() > 0)
                <form id="delete-criteria-form" method="POST">
                    @csrf
                    @method('DELETE')

                    <div class="mt-6 flex justify-between items-center">
                        <!-- Tìm kiếm Tiêu chí -->
                        <input type="text" id="search-input"
                            class="w-1/3 px-2 py-2 text-black rounded-lg shadow-md"
                            placeholder="🔍 Nhập Tiêu chí để tìm kiếm...">

                        <!-- Các nút thao tác -->
                        <div class="flex gap-2">
                            <a href="{{ route('criteria.create') }} "
                                class="inline-flex items-center px-4 py-2 bg-green-600 text-white rounded-md shadow hover:bg-green-700">
                                ➕ Thêm
                            </a>

                            <button type="button" id="edit-btn"
                                class="inline-flex items-center px-4 py-2 bg-yellow-600 text-white rounded-md shadow hover:bg-yellow-700">
                                ✏️ Sửa
                            </button>

                            <button type="button" id="delete-btn"
                                class="inline-flex items-center px-4 py-2 bg-red-600 text-white rounded-md shadow hover:bg-red-700">
                                🗑️ Xóa
                            </button>
                        </div>
                    </div>

                    <table class="w-full border border-red-500 rounded-lg shadow-lg text-white mt-4">
                        <thead class="bg-gray-700 text-red-400 uppercase">
                            <tr>
                                <th class="border border-red-500 px-4 py-3 text-left">
                                    <input type="checkbox" id="select-all" class="form-checkbox">
                                </th>
                                <th class="border border-red-500 px-4 py-3 text-left">🌐 Danh mục</th>
                                <th class="border border-red-500 px-4 py-3 text-left">📌 Từ khóa</th>
                            </tr>
                        </thead>
                        <tbody class="bg-gray-800 divide-y divide-gray-700">
                            @foreach ($criteria as $item)
                            <tr class="hover:bg-gray-700 transition-all duration-300">
                                <td class="border border-red-500 px-4 py-3 text-center w-10">
                                    <input type="checkbox" name="criteria[]" value="{{ $item->id }}" class="form-checkbox criteria-checkbox">
                                </td>
                                <td class="border border-red-500 px-4 py-3 font-mono text-red-300">
                                    {{ $item->type }}
                                </td>
                                <td class="border border-red-500 px-4 py-3 text-gray-300">
                                    {{ implode(', ', json_decode($item->keywords)) }}
                                </td>
                            </tr>
                            @endforeach
                        </tbody>
                    </table>

                </form>
                @else
                <p class="text-gray-400">⚠️ Danh sách Tiêu chí trống.</p>
                @endif
            </div>
        </div>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            // Xử lý chọn tất cả checkbox
            let selectAllCheckbox = document.getElementById('select-all');
            if (selectAllCheckbox) {
                selectAllCheckbox.addEventListener('change', function() {
                    document.querySelectorAll('.criteria-checkbox').forEach(checkbox => {
                        checkbox.checked = this.checked;
                    });
                });
            }

            // Xử lý tìm kiếm danh sách Tiêu chí
            let searchInput = document.getElementById("search-input");
            if (searchInput) {
                searchInput.addEventListener("keyup", function() {
                    let filter = searchInput.value.toLowerCase();
                    let rows = document.querySelectorAll("tbody tr");

                    rows.forEach(row => {
                        let type = row.querySelector("td:nth-child(2)").textContent.toLowerCase();
                        if (type.includes(filter)) {
                            row.style.display = "";
                        } else {
                            row.style.display = "none";
                        }
                    });
                });
            }

            // Xử lý nút "Sửa"
            document.getElementById("edit-btn").addEventListener("click", function() {
                let selectedIds = [];
                document.querySelectorAll('.criteria-checkbox:checked').forEach(checkbox => {
                    selectedIds.push(checkbox.value);
                });

                if (selectedIds.length === 0) {
                    alert("⚠️ Vui lòng chọn ít nhất một tiêu chí để chỉnh sửa!");
                    return;
                }

                // Chuyển hướng đến trang chỉnh sửa với danh sách ID được chọn
                let editUrl = "{{ route('criteria.edit', ':id') }}".replace(':id', selectedIds[0]);
                window.location.href = editUrl;
            });

            // Xử lý nút "Xóa"
            document.getElementById("delete-btn").addEventListener("click", function() {
                let selectedIds = [];
                document.querySelectorAll('.criteria-checkbox:checked').forEach(checkbox => {
                    selectedIds.push(checkbox.value);
                });

                if (selectedIds.length === 0) {
                    alert("⚠️ Vui lòng chọn ít nhất một tiêu chí để xóa!");
                    return;
                }

                if (confirm("⚠️ Bạn có chắc chắn muốn xóa các tiêu chí đã chọn?")) {
                    let form = document.createElement("form");
                    form.method = "POST";
                    form.action = "{{ route('criteria.destroy', ':id') }}".replace(':id', selectedIds.join(','));

                    let csrfField = document.createElement("input");
                    csrfField.type = "hidden";
                    csrfField.name = "_token";
                    csrfField.value = "{{ csrf_token() }}";
                    form.appendChild(csrfField);

                    let methodField = document.createElement("input");
                    methodField.type = "hidden";
                    methodField.name = "_method";
                    methodField.value = "DELETE";
                    form.appendChild(methodField);

                    selectedIds.forEach(id => {
                        let input = document.createElement("input");
                        input.type = "hidden";
                        input.name = "criteria[]";
                        input.value = id;
                        form.appendChild(input);
                    });

                    document.body.appendChild(form);
                    form.submit();
                }
            });
        });
    </script>

</x-app-layout>
