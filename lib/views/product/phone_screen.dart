import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:phone_shop/hooks/fetch_phones.dart';

class PhoneScreen extends HookWidget {
  const PhoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final phonesHook = useFetchPhones();
    return Builder(
      builder: (context) {
        if (phonesHook.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (phonesHook.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${phonesHook.error}'),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: phonesHook.refetch,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final phones = phonesHook.data ?? [];

        if (phones.isEmpty) {
          return const Center(child: Text('No phones found.'));
        }

        return RefreshIndicator(
          onRefresh: () async => phonesHook.refetch?.call(),
          child: ListView.builder(
            itemCount: phones.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final phone = phones[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: phone.image != null
                      ? Image.network(phone.image!,
                          width: 60, height: 60, fit: BoxFit.cover)
                      : const Icon(Icons.phone_android, size: 40),
                  title: Text("${phone.brand} ${phone.model}"),
                  subtitle: Text(
                      "${phone.currency} ${phone.price} • Stock: ${phone.stock}"),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
